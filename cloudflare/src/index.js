const encoder = new TextEncoder();

const jsonResponse = (data, status = 200) => {
    return new Response(JSON.stringify(data), {
        status,
        headers: {
            "content-type": "application/json",
            "access-control-allow-origin": "*",
            "access-control-allow-methods": "GET,POST,DELETE,OPTIONS",
            "access-control-allow-headers": "content-type,authorization,x-migration-token",
        },
    });
};

const badRequest = (message) => jsonResponse({ error: message }, 400);
const unauthorized = (message) => jsonResponse({ error: message }, 401);

const base64UrlEncode = (input) => {
    const bytes = typeof input === "string" ? encoder.encode(input) : input;
    let binary = "";
    for (let i = 0; i < bytes.length; i += 1) {
        binary += String.fromCharCode(bytes[i]);
    }
    return btoa(binary).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
};

const base64UrlDecode = (input) => {
    const padding = "=".repeat((4 - (input.length % 4)) % 4);
    const base64 = (input + padding).replace(/-/g, "+").replace(/_/g, "/");
    const binary = atob(base64);
    const bytes = new Uint8Array(binary.length);
    for (let i = 0; i < binary.length; i += 1) {
        bytes[i] = binary.charCodeAt(i);
    }
    return bytes;
};

const hmacSign = async (secret, data) => {
    const key = await crypto.subtle.importKey(
        "raw",
        encoder.encode(secret),
        { name: "HMAC", hash: "SHA-256" },
        false,
        ["sign"],
    );
    const signature = await crypto.subtle.sign("HMAC", key, encoder.encode(data));
    return new Uint8Array(signature);
};

const signJwt = async (payload, secret) => {
    const header = { alg: "HS256", typ: "JWT" };
    const headerPart = base64UrlEncode(JSON.stringify(header));
    const payloadPart = base64UrlEncode(JSON.stringify(payload));
    const data = `${headerPart}.${payloadPart}`;
    const signature = await hmacSign(secret, data);
    return `${data}.${base64UrlEncode(signature)}`;
};

const verifyJwt = async (token, secret) => {
    const parts = token.split(".");
    if (parts.length !== 3) {
        return null;
    }
    const [headerPart, payloadPart, signaturePart] = parts;
    const data = `${headerPart}.${payloadPart}`;
    const expected = await hmacSign(secret, data);
    const actual = base64UrlDecode(signaturePart);
    if (expected.length !== actual.length) {
        return null;
    }
    for (let i = 0; i < expected.length; i += 1) {
        if (expected[i] !== actual[i]) {
            return null;
        }
    }
    const payloadBytes = base64UrlDecode(payloadPart);
    const payload = JSON.parse(new TextDecoder().decode(payloadBytes));
    if (payload.exp && Date.now() / 1000 > payload.exp) {
        return null;
    }
    return payload;
};

const hashPassword = async (password) => {
    const salt = crypto.getRandomValues(new Uint8Array(16));
    const key = await crypto.subtle.importKey(
        "raw",
        encoder.encode(password),
        { name: "PBKDF2" },
        false,
        ["deriveBits"],
    );
    const hashBuffer = await crypto.subtle.deriveBits(
        {
            name: "PBKDF2",
            salt,
            iterations: 100000,
            hash: "SHA-256",
        },
        key,
        256,
    );
    const hash = new Uint8Array(hashBuffer);
    const toHex = (bytes) => Array.from(bytes).map((b) => b.toString(16).padStart(2, "0")).join("");
    return { salt: toHex(salt), hash: toHex(hash) };
};

const verifyPassword = async (password, saltHex, hashHex) => {
    const fromHex = (hex) => {
        const bytes = new Uint8Array(hex.length / 2);
        for (let i = 0; i < bytes.length; i += 1) {
            bytes[i] = parseInt(hex.substr(i * 2, 2), 16);
        }
        return bytes;
    };
    const salt = fromHex(saltHex);
    const key = await crypto.subtle.importKey(
        "raw",
        encoder.encode(password),
        { name: "PBKDF2" },
        false,
        ["deriveBits"],
    );
    const hashBuffer = await crypto.subtle.deriveBits(
        { name: "PBKDF2", salt, iterations: 100000, hash: "SHA-256" },
        key,
        256,
    );
    const hash = new Uint8Array(hashBuffer);
    const expected = hashHex;
    const actual = Array.from(hash).map((b) => b.toString(16).padStart(2, "0")).join("");
    return expected === actual;
};

const getAuthUser = async (request, env) => {
    const authHeader = request.headers.get("authorization");
    if (!authHeader) {
        return null;
    }
    const parts = authHeader.split(" ");
    if (parts.length !== 2 || parts[0] !== "Bearer") {
        return null;
    }
    return verifyJwt(parts[1], env.JWT_SECRET);
};

const isMigrationRequest = (request, env) => {
    const token = request.headers.get("x-migration-token");
    if (!token || !env.MIGRATION_TOKEN) {
        return false;
    }
    return token === env.MIGRATION_TOKEN;
};

const tableByType = (type) => {
    switch (type) {
        case "doctor":
            return "doctors";
        case "profession":
            return "professions";
        case "car":
            return "cars";
        case "satota":
            return "satota";
        case "donor":
            return "donors";
        default:
            return null;
    }
};

const parseJsonBody = async (request) => {
    try {
        return await request.json();
    } catch (error) {
        return null;
    }
};

const parsePagination = (url) => {
    const limitParam = Number(url.searchParams.get("limit"));
    const pageParam = Number(url.searchParams.get("page"));
    const limit = Number.isFinite(limitParam) && limitParam > 0 ? Math.min(limitParam, 200) : 50;
    const page = Number.isFinite(pageParam) && pageParam > 0 ? pageParam : 1;
    const offset = (page - 1) * limit;
    return { limit, offset };
};

export default {
    async fetch(request, env) {
        if (request.method === "OPTIONS") {
            return jsonResponse({ ok: true }, 200);
        }

        const url = new URL(request.url);
        const path = url.pathname;

        if (path === "/health") {
            return jsonResponse({ ok: true, app: env.APP_NAME || "app" });
        }

        if (path === "/auth/register" && request.method === "POST") {
            const body = await parseJsonBody(request);
            if (!body) {
                return badRequest("Invalid JSON");
            }
            const { name, email, phone, password } = body;
            if (!name || !email || !phone || !password) {
                return badRequest("Missing required fields");
            }

            const existing = await env.DB.prepare(
                "SELECT id FROM users WHERE email = ? OR phone = ? LIMIT 1",
            )
                .bind(email, phone)
                .first();
            if (existing) {
                return badRequest("User already exists");
            }

            const now = Date.now();
            const { hash, salt } = await hashPassword(password);
            const userId = crypto.randomUUID();
            await env.DB.prepare(
                "INSERT INTO users (id, name, email, phone, password_hash, password_salt, created_at, last_login, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)",
            )
                .bind(userId, name, email, phone, hash, salt, now, now)
                .run();

            const token = await signJwt(
                {
                    sub: userId,
                    phone,
                    name,
                    exp: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 30,
                },
                env.JWT_SECRET,
            );

            return jsonResponse({
                token,
                user: { id: userId, name, email, phone },
            });
        }

        if (path === "/auth/login" && request.method === "POST") {
            const body = await parseJsonBody(request);
            if (!body) {
                return badRequest("Invalid JSON");
            }
            const { phone, password } = body;
            if (!phone || !password) {
                return badRequest("Missing required fields");
            }

            const user = await env.DB.prepare(
                "SELECT id, name, email, phone, password_hash, password_salt, is_active FROM users WHERE phone = ? LIMIT 1",
            )
                .bind(phone)
                .first();
            if (!user || user.is_active !== 1) {
                return unauthorized("Invalid credentials");
            }

            const isValid = await verifyPassword(
                password,
                user.password_salt,
                user.password_hash,
            );
            if (!isValid) {
                return unauthorized("Invalid credentials");
            }

            await env.DB.prepare("UPDATE users SET last_login = ? WHERE id = ?")
                .bind(Date.now(), user.id)
                .run();

            const token = await signJwt(
                {
                    sub: user.id,
                    phone: user.phone,
                    name: user.name,
                    exp: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 30,
                },
                env.JWT_SECRET,
            );

            return jsonResponse({
                token,
                user: { id: user.id, name: user.name, email: user.email, phone: user.phone },
            });
        }

        if (path === "/auth/reset-password" && request.method === "POST") {
            const body = await parseJsonBody(request);
            if (!body) {
                return badRequest("Invalid JSON");
            }
            const { email, newPassword } = body;
            if (!email || !newPassword) {
                return badRequest("Missing required fields");
            }

            const user = await env.DB.prepare(
                "SELECT id FROM users WHERE email = ? LIMIT 1",
            )
                .bind(email)
                .first();
            if (!user) {
                return badRequest("User not found");
            }

            const { hash, salt } = await hashPassword(newPassword);
            await env.DB.prepare(
                "UPDATE users SET password_hash = ?, password_salt = ? WHERE id = ?",
            )
                .bind(hash, salt, user.id)
                .run();

            return jsonResponse({ ok: true });
        }

        if (path === "/auth/check-email" && request.method === "GET") {
            const email = url.searchParams.get("email");
            if (!email) {
                return badRequest("Missing email");
            }

            const user = await env.DB.prepare(
                "SELECT id FROM users WHERE email = ? LIMIT 1",
            )
                .bind(email)
                .first();

            return jsonResponse({ exists: !!user });
        }

        if (path === "/donors" && request.method === "GET") {
            const bloodType = url.searchParams.get("bloodType");
            const number = url.searchParams.get("number");
            const { limit, offset } = parsePagination(url);
            let query = "SELECT id, name, phone AS number, location, blood_type AS type FROM donors WHERE is_active = 1";
            const params = [];
            if (bloodType) {
                query += " AND blood_type = ?";
                params.push(bloodType);
            }
            if (number) {
                query += " AND phone = ?";
                params.push(number);
            }
            query += " ORDER BY created_at DESC LIMIT ? OFFSET ?";
            params.push(limit, offset);
            const result = await env.DB.prepare(query).bind(...params).all();
            return jsonResponse(result.results || []);
        }

        if (path === "/doctors" && request.method === "GET") {
            const { limit, offset } = parsePagination(url);
            const result = await env.DB.prepare(
                "SELECT id, name, phone AS number, specialization, presence, title FROM doctors WHERE is_active = 1 ORDER BY created_at DESC LIMIT ? OFFSET ?",
            )
                .bind(limit, offset)
                .all();
            return jsonResponse(result.results || []);
        }

        if (path === "/professions" && request.method === "GET") {
            const { limit, offset } = parsePagination(url);
            const result = await env.DB.prepare(
                "SELECT id, name, phone AS number, name_profession AS nameProfession FROM professions WHERE is_active = 1 ORDER BY created_at DESC LIMIT ? OFFSET ?",
            )
                .bind(limit, offset)
                .all();
            return jsonResponse(result.results || []);
        }

        if (path === "/cars" && request.method === "GET") {
            const { limit, offset } = parsePagination(url);
            const result = await env.DB.prepare(
                "SELECT id, name, phone AS number, vehicle_type AS type, time, route_from AS 'from' FROM cars WHERE is_active = 1 ORDER BY created_at DESC LIMIT ? OFFSET ?",
            )
                .bind(limit, offset)
                .all();
            return jsonResponse(result.results || []);
        }

        if (path === "/satota" && request.method === "GET") {
            const { limit, offset } = parsePagination(url);
            const result = await env.DB.prepare(
                "SELECT id, name, phone AS number, location FROM satota WHERE is_active = 1 ORDER BY created_at DESC LIMIT ? OFFSET ?",
            )
                .bind(limit, offset)
                .all();
            return jsonResponse(result.results || []);
        }

        if (["/donors", "/doctors", "/professions", "/cars", "/satota"].includes(path) && request.method === "POST") {
            const user = await getAuthUser(request, env);
            const isMigration = isMigrationRequest(request, env);
            if (!user && !isMigration) {
                return unauthorized("Missing or invalid token");
            }
            const body = await parseJsonBody(request);
            if (!body) {
                return badRequest("Invalid JSON");
            }

            const id = crypto.randomUUID();
            const now = Date.now();

            if (path === "/donors") {
                const { name, phone, location, bloodType } = body;
                if (!name || !phone || !location || !bloodType) {
                    return badRequest("Missing required fields");
                }
                await env.DB.prepare(
                    "INSERT INTO donors (id, name, phone, location, blood_type, created_by, created_at, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, 1)",
                )
                    .bind(id, name, phone, location, bloodType, user?.sub ?? "migration", now)
                    .run();
                return jsonResponse({ id }, 201);
            }

            if (path === "/doctors") {
                const { name, phone, specialization, presence, title } = body;
                if (!name || !phone || !specialization || !presence || !title) {
                    return badRequest("Missing required fields");
                }
                await env.DB.prepare(
                    "INSERT INTO doctors (id, name, phone, specialization, presence, title, created_by, created_at, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)",
                )
                    .bind(id, name, phone, specialization, presence, title, user?.sub ?? "migration", now)
                    .run();
                return jsonResponse({ id }, 201);
            }

            if (path === "/professions") {
                const { name, phone, nameProfession } = body;
                if (!name || !phone || !nameProfession) {
                    return badRequest("Missing required fields");
                }
                await env.DB.prepare(
                    "INSERT INTO professions (id, name, phone, name_profession, created_by, created_at, is_active) VALUES (?, ?, ?, ?, ?, ?, 1)",
                )
                    .bind(id, name, phone, nameProfession, user?.sub ?? "migration", now)
                    .run();
                return jsonResponse({ id }, 201);
            }

            if (path === "/cars") {
                const { name, phone, vehicleType, time, routeFrom } = body;
                if (!name || !phone || !vehicleType || !time || !routeFrom) {
                    return badRequest("Missing required fields");
                }
                await env.DB.prepare(
                    "INSERT INTO cars (id, name, phone, vehicle_type, time, route_from, created_by, created_at, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)",
                )
                    .bind(id, name, phone, vehicleType, time, routeFrom, user?.sub ?? "migration", now)
                    .run();
                return jsonResponse({ id }, 201);
            }

            if (path === "/satota") {
                const { name, phone, location } = body;
                if (!name || !phone || !location) {
                    return badRequest("Missing required fields");
                }
                await env.DB.prepare(
                    "INSERT INTO satota (id, name, phone, location, created_by, created_at, is_active) VALUES (?, ?, ?, ?, ?, ?, 1)",
                )
                    .bind(id, name, phone, location, user?.sub ?? "migration", now)
                    .run();
                return jsonResponse({ id }, 201);
            }
        }

        if (path === "/lookup" && request.method === "GET") {
            const type = url.searchParams.get("type");
            const number = url.searchParams.get("number");
            if (!type || !number) {
                return badRequest("Missing type or number");
            }
            const table = tableByType(type);
            if (!table) {
                return badRequest("Unknown type");
            }
            const query = `SELECT id FROM ${table} WHERE phone = ? LIMIT 1`;
            const result = await env.DB.prepare(query).bind(number).first();
            if (!result) {
                return jsonResponse({ found: false });
            }
            return jsonResponse({ found: true, id: result.id, type });
        }

        if (path === "/items" && request.method === "DELETE") {
            const user = await getAuthUser(request, env);
            if (!user) {
                return unauthorized("Missing or invalid token");
            }
            const type = url.searchParams.get("type");
            const id = url.searchParams.get("id");
            if (!type || !id) {
                return badRequest("Missing type or id");
            }
            const table = tableByType(type);
            if (!table) {
                return badRequest("Unknown type");
            }
            await env.DB.prepare(`DELETE FROM ${table} WHERE id = ?`).bind(id).run();
            return jsonResponse({ ok: true });
        }

        if (path === "/auth/by-phone" && request.method === "DELETE") {
            const user = await getAuthUser(request, env);
            if (!user) {
                return unauthorized("Missing or invalid token");
            }
            const phone = url.searchParams.get("phone");
            if (!phone) {
                return badRequest("Missing phone");
            }
            await env.DB.prepare("DELETE FROM users WHERE phone = ?").bind(phone).run();
            return jsonResponse({ ok: true });
        }

        return jsonResponse({ error: "Not found" }, 404);
    },
};
