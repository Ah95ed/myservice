const encoder = new TextEncoder();

export const corsHeaders = {
  "access-control-allow-origin": "*",
  "access-control-allow-methods": "GET,POST,PUT,DELETE,OPTIONS",
  "access-control-allow-headers":
    "content-type,authorization,x-migration-token",
};

export const jsonResponse = (data, status = 200) => {
  return new Response(JSON.stringify(data), {
    status,
    headers: { "content-type": "application/json", ...corsHeaders },
  });
};

export const htmlResponse = (html, status = 200) => {
  return new Response(html, {
    status,
    headers: {
      "content-type": "text/html; charset=utf-8",
      "cache-control": "no-store",
      ...corsHeaders,
    },
  });
};

export const badRequest = (message) => jsonResponse({ error: message }, 400);
export const unauthorized = (message) => jsonResponse({ error: message }, 401);

export const base64UrlEncode = (input) => {
  const bytes = typeof input === "string" ? encoder.encode(input) : input;
  let binary = "";
  for (let i = 0; i < bytes.length; i += 1) {
    binary += String.fromCharCode(bytes[i]);
  }
  return btoa(binary)
    .replace(/\+/g, "-")
    .replace(/\//g, "_")
    .replace(/=+$/, "");
};

export const base64UrlDecode = (input) => {
  const padding = "=".repeat((4 - (input.length % 4)) % 4);
  const base64 = (input + padding).replace(/-/g, "+").replace(/_/g, "/");
  const binary = atob(base64);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i += 1) {
    bytes[i] = binary.charCodeAt(i);
  }
  return bytes;
};

export const hmacSign = async (secret, data) => {
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

export const sha256Hex = async (input) => {
  const bytes = typeof input === "string" ? encoder.encode(input) : input;
  const hashBuffer = await crypto.subtle.digest("SHA-256", bytes);
  const hash = new Uint8Array(hashBuffer);
  return Array.from(hash)
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
};

export const generateOneTimeToken = () => {
  const bytes = crypto.getRandomValues(new Uint8Array(32));
  return base64UrlEncode(bytes);
};

export const signJwt = async (payload, secret) => {
  const header = { alg: "HS256", typ: "JWT" };
  const headerPart = base64UrlEncode(JSON.stringify(header));
  const payloadPart = base64UrlEncode(JSON.stringify(payload));
  const data = `${headerPart}.${payloadPart}`;
  const signature = await hmacSign(secret, data);
  return `${data}.${base64UrlEncode(signature)}`;
};

export const verifyJwt = async (token, secret) => {
  if (!token) return null;
  const parts = token.split(".");
  if (parts.length !== 3) return null;
  const [headerPart, payloadPart, signaturePart] = parts;
  const data = `${headerPart}.${payloadPart}`;
  const expected = await hmacSign(secret, data);
  const actual = base64UrlDecode(signaturePart);
  if (expected.length !== actual.length) return null;
  for (let i = 0; i < expected.length; i += 1) {
    if (expected[i] !== actual[i]) return null;
  }
  const payloadBytes = base64UrlDecode(payloadPart);
  const payload = JSON.parse(new TextDecoder().decode(payloadBytes));
  if (payload.exp && Date.now() / 1000 > payload.exp) return null;
  return payload;
};

export const hashPassword = async (password) => {
  const salt = crypto.getRandomValues(new Uint8Array(16));
  const key = await crypto.subtle.importKey(
    "raw",
    encoder.encode(password),
    { name: "PBKDF2" },
    false,
    ["deriveBits"],
  );
  const hashBuffer = await crypto.subtle.deriveBits(
    { name: "PBKDF2", salt, iterations: 50000, hash: "SHA-256" },
    key,
    256,
  );
  const hash = new Uint8Array(hashBuffer);
  const toHex = (bytes) =>
    Array.from(bytes)
      .map((b) => b.toString(16).padStart(2, "0"))
      .join("");
  return { salt: toHex(salt), hash: toHex(hash) };
};

export const verifyPassword = async (password, saltHex, hashHex) => {
  if (!password || !saltHex || !hashHex) return false;
  const fromHex = (hex) => {
    const cleanHex = hex.trim().toLowerCase();
    const bytes = new Uint8Array(cleanHex.length / 2);
    for (let i = 0; i < bytes.length; i += 1) {
      bytes[i] = parseInt(cleanHex.substring(i * 2, i * 2 + 2), 16);
    }
    return bytes;
  };
  try {
    const salt = fromHex(saltHex);
    const key = await crypto.subtle.importKey(
      "raw",
      encoder.encode(password),
      { name: "PBKDF2" },
      false,
      ["deriveBits"],
    );
    const hashBuffer = await crypto.subtle.deriveBits(
      { name: "PBKDF2", salt, iterations: 50000, hash: "SHA-256" },
      key,
      256,
    );
    const hash = new Uint8Array(hashBuffer);
    const actual = Array.from(hash)
      .map((b) => b.toString(16).padStart(2, "0"))
      .join("");
    return hashHex.trim().toLowerCase() === actual;
  } catch (e) {
    console.error("Verification error:", e);
    return false;
  }
};

export const validateAuthInput = (data, type = "login") => {
  const errors = [];
  if (type === "register" && (!data.name || data.name.trim().length < 2))
    errors.push("الاسم قصير جداً");
  if (!data.phone || !/^\d{10,15}$/.test(data.phone.trim()))
    errors.push("رقم الهاتف غير صحيح");
  if (!data.password || data.password.trim().length < 6)
    errors.push("كلمة المرور يجب أن تكون 6 أحرف على الأقل");
  if (
    type === "register" &&
    (!data.email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(data.email.trim()))
  )
    errors.push("البريد الإلكتروني غير صحيح");
  return errors;
};

export const getAuthUser = async (request, env) => {
  const authHeader = request.headers.get("authorization");
  if (!authHeader) return null;
  const parts = authHeader.split(" ");
  if (parts.length !== 2 || parts[0] !== "Bearer") return null;
  return verifyJwt(parts[1], env.JWT_SECRET);
};

export const isMigrationRequest = (request, env) => {
  const token = request.headers.get("x-migration-token");
  if (!token || !env.MIGRATION_TOKEN) return false;
  return token === env.MIGRATION_TOKEN;
};

export const tableByType = (type) => {
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

export const parseJsonBody = async (request) => {
  try {
    return await request.json();
  } catch (error) {
    return null;
  }
};

export const parsePagination = (url) => {
  const limitParam = Number(url.searchParams.get("limit"));
  const pageParam = Number(url.searchParams.get("page"));
  const limit =
    Number.isFinite(limitParam) && limitParam > 0
      ? Math.min(limitParam, 200)
      : 50;
  const page = Number.isFinite(pageParam) && pageParam > 0 ? pageParam : 1;
  const offset = (page - 1) * limit;
  return { limit, offset };
};

export const parseFormBody = async (request) => {
  const bodyText = await request.text();
  return new URLSearchParams(bodyText);
};

export const normalizeEmail = (value) => (value || "").trim().toLowerCase();

export const generateOtpCode = () => {
  const random = crypto.getRandomValues(new Uint32Array(1))[0] % 1000000;
  return String(random).padStart(6, "0");
};

export const sendOtpEmail = async (
  env,
  toEmail,
  code,
  subject = "رمز التحقق",
  title = "تأكيد العملية",
) => {
  if (!env.RESEND_API_KEY || !env.OTP_EMAIL_FROM) {
    console.warn("Email OTP is not configured. Skipping email send.");
    return;
  }
  const response = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      "content-type": "application/json",
      authorization: `Bearer ${env.RESEND_API_KEY}`,
    },
    body: JSON.stringify({
      from: env.OTP_EMAIL_FROM,
      to: [toEmail],
      subject: subject,
      html: `<div dir="rtl" style="font-family: Arial, sans-serif; line-height: 1.7;">
<h2>${title}</h2>
<p>رمز التحقق الخاص بك هو:</p>
<div style="font-size: 30px; font-weight: bold; letter-spacing: 6px;">${code}</div>
<p>ينتهي الرمز خلال 10 دقائق.</p>
<p>إذا لم تطلب هذه العملية، تجاهل هذه الرسالة.</p>
</div>`,
    }),
  });
  if (!response.ok) {
    const text = await response.text();
    throw new Error(`Failed to send OTP email (${response.status}): ${text}`);
  }
};

export const getEditableColumns = (type) => {
  switch (type) {
    case "doctor":
      return ["name", "phone", "specialization", "presence", "title"];
    case "profession":
      return ["name", "phone", "name_profession"];
    case "car":
      return ["name", "phone", "vehicle_type", "time", "route_from"];
    case "satota":
      return ["name", "phone", "location"];
    case "donor":
      return ["name", "phone", "location", "blood_type"];
    default:
      return [];
  }
};

export const mapUpdatePayload = (type, body) => {
  if (type === "doctor")
    return {
      name: body.name,
      phone: body.phone,
      specialization: body.specialization,
      presence: body.presence,
      title: body.title,
    };
  if (type === "profession")
    return {
      name: body.name,
      phone: body.phone,
      name_profession: body.nameProfession,
    };
  if (type === "car")
    return {
      name: body.name,
      phone: body.phone,
      vehicle_type: body.vehicleType,
      time: body.time,
      route_from: body.routeFrom,
    };
  if (type === "satota")
    return { name: body.name, phone: body.phone, location: body.location };
  if (type === "donor")
    return {
      name: body.name,
      phone: body.phone,
      location: body.location,
      blood_type: body.bloodType,
    };
  return {};
};

export const getPreferredLocale = (request) => {
  const header = request.headers.get("accept-language") || "";
  return header.toLowerCase().includes("ar") ? "ar" : "en";
};

export const getConfigToken = (request) => {
  const authHeader = request.headers.get("authorization");
  if (authHeader) {
    const parts = authHeader.split(" ");
    if (parts.length === 2 && parts[0] === "Bearer") return parts[1];
  }
  return request.headers.get("x-config-token");
};

export const isConfigAuthorized = (request, env) => {
  const token = getConfigToken(request);
  if (!token || !env.CONFIG_TOKEN) return false;
  return token === env.CONFIG_TOKEN;
};

export const isR2Authorized = (request, env) => {
  const token = getConfigToken(request);
  if (!token || !env.R2_TOKEN) return false;
  return token === env.R2_TOKEN;
};

export const getConfigPayload = async (env) => {
  const defaults = {
    update: "0",
    r2_account_id: "",
    r2_endpoint: "",
    r2_access_key_id: "",
    r2_secret_access_key: "",
    r2_bucket: "",
  };
  if (!env.CONFIG_KV) return defaults;
  const stored = await env.CONFIG_KV.get("remote_config", { type: "json" });
  if (!stored || typeof stored !== "object") return defaults;
  return { ...defaults, ...stored };
};
