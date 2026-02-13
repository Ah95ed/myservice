const encoder = new TextEncoder();

const corsHeaders = {
    "access-control-allow-origin": "*",
    "access-control-allow-methods": "GET,POST,PUT,DELETE,OPTIONS",
    "access-control-allow-headers": "content-type,authorization,x-migration-token",
};

const jsonResponse = (data, status = 200) => {
    return new Response(JSON.stringify(data), {
        status,
        headers: {
            "content-type": "application/json",
            ...corsHeaders,
        },
    });
};

const htmlResponse = (html, status = 200) => {
    return new Response(html, {
        status,
        headers: {
            "content-type": "text/html; charset=utf-8",
            "cache-control": "no-store",
            ...corsHeaders,
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

const sha256Hex = async (input) => {
    const bytes = typeof input === "string" ? encoder.encode(input) : input;
    const hashBuffer = await crypto.subtle.digest("SHA-256", bytes);
    const hash = new Uint8Array(hashBuffer);
    return Array.from(hash)
        .map((b) => b.toString(16).padStart(2, "0"))
        .join("");
};

const generateOneTimeToken = () => {
    const bytes = crypto.getRandomValues(new Uint8Array(32));
    return base64UrlEncode(bytes);
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

const parseFormBody = async (request) => {
    const bodyText = await request.text();
    return new URLSearchParams(bodyText);
};

const normalizeEmail = (value) => (value || "").trim().toLowerCase();

const generateOtpCode = () => {
    const random = crypto.getRandomValues(new Uint32Array(1))[0] % 1000000;
    return String(random).padStart(6, "0");
};

const sendOtpEmail = async (env, toEmail, code) => {
    if (!env.RESEND_API_KEY || !env.OTP_EMAIL_FROM) {
        throw new Error("Email OTP is not configured on the server");
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
            subject: "رمز تأكيد حذف الحساب",
            html: `<div dir="rtl" style="font-family: Arial, sans-serif; line-height: 1.7;">
<h2>تأكيد حذف الحساب</h2>
<p>رمز التحقق الخاص بك هو:</p>
<div style="font-size: 30px; font-weight: bold; letter-spacing: 6px;">${code}</div>
<p>ينتهي الرمز خلال 10 دقائق، ويسمح لك بحذف كل الإعلانات والحساب نهائياً.</p>
<p>إذا لم تطلب هذه العملية، تجاهل هذه الرسالة.</p>
</div>`,
        }),
    });

    if (!response.ok) {
        const text = await response.text();
        throw new Error(`Failed to send OTP email (${response.status}): ${text}`);
    }
};

const getEditableColumns = (type) => {
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

const mapUpdatePayload = (type, body) => {
    if (type === "doctor") {
        return {
            name: body.name,
            phone: body.phone,
            specialization: body.specialization,
            presence: body.presence,
            title: body.title,
        };
    }
    if (type === "profession") {
        return {
            name: body.name,
            phone: body.phone,
            name_profession: body.nameProfession,
        };
    }
    if (type === "car") {
        return {
            name: body.name,
            phone: body.phone,
            vehicle_type: body.vehicleType,
            time: body.time,
            route_from: body.routeFrom,
        };
    }
    if (type === "satota") {
        return {
            name: body.name,
            phone: body.phone,
            location: body.location,
        };
    }
    if (type === "donor") {
        return {
            name: body.name,
            phone: body.phone,
            location: body.location,
            blood_type: body.bloodType,
        };
    }
    return {};
};

const getPreferredLocale = (request) => {
    const header = request.headers.get("accept-language") || "";
    return header.toLowerCase().includes("ar") ? "ar" : "en";
};

const WEB_COPY = {
    en: {
        confirmTitle: "Confirm Account Deletion",
        confirmHeading: "Confirm account deletion",
        confirmBody:
            "This action permanently deletes your account and data. You will not be able to recover it.",
        confirmWarning: "This link can be used only once and expires soon.",
        confirmInfoTitle: "How deletion works",
        confirmInfoBody:
            "This request contains a one-time token created by the app. Confirming below completes the deletion.",
        confirmButton: "Confirm delete account",
        invalidTitle: "Invalid link",
        missingToken: "Missing deletion token.",
        invalidOrExpired: "This deletion link is invalid or expired.",
        usedTitle: "Link already used",
        usedMessage: "This deletion link has already been used.",
        expiredTitle: "Link expired",
        expiredMessage: "This deletion link has expired. Please request a new one from the app.",
        successTitle: "Account deleted",
        successMessage: "Your account and data have been deleted successfully.",
        infoTitle: "Delete account guide",
        infoHeading: "How to delete your account",
        infoIntro:
            "To request deletion, you must use the app so we can generate a secure one-time link.",
        infoSteps:
            "Open the app and go to Profile.\nTap Delete Account.\nConfirm to open the secure deletion page.\nPress Confirm delete account to finish.",
        infoNote:
            "The deletion link expires quickly and can only be used once.",
        infoScreensIntro: "Screenshots below show the exact flow in order.",
        infoScreensHeading: "Step-by-step screenshots",
        infoStep1Title: "Step 1: Open Profile",
        infoStep1Body: "From the main screen, open your profile to access account actions.",
        infoStep2Title: "Step 2: Tap Delete Account",
        infoStep2Body: "Select Delete Account to open the secure deletion flow.",
        infoStep3Title: "Step 3: Confirm deletion",
        infoStep3Body: "Review the warning and press Confirm delete account to finish.",
        infoActionTitle: "Request deletion",
        infoActionBody:
            "If you are signed in, you can request a secure deletion link now.",
        infoActionButton: "Request delete link",
        infoMissingToken:
            "Sign in through the app to request a deletion link. This page alone cannot identify you.",
        requestLinkTitle: "Deletion link ready",
        requestLinkBody:
            "Open the secure deletion page using the button below.",
        requestLinkButton: "Open delete page",
    },
    ar: {
        confirmTitle: "\u062a\u0623\u0643\u064a\u062f \u062d\u0630\u0641 \u0627\u0644\u062d\u0633\u0627\u0628",
        confirmHeading: "\u062a\u0623\u0643\u064a\u062f \u062d\u0630\u0641 \u0627\u0644\u062d\u0633\u0627\u0628",
        confirmBody:
            "\u0633\u064a\u062a\u0645 \u062d\u0630\u0641 \u0627\u0644\u062d\u0633\u0627\u0628 \u0648\u0627\u0644\u0628\u064a\u0627\u0646\u0627\u062a \u0646\u0647\u0627\u0626\u064a\u0627\u064b. \u0644\u0646 \u062a\u062a\u0645\u0643\u0646 \u0645\u0646 \u0627\u0633\u062a\u0631\u062c\u0627\u0639\u0647\u0627.",
        confirmWarning:
            "\u0647\u0630\u0627 \u0627\u0644\u0631\u0627\u0628\u0637 \u064a\u0633\u062a\u062e\u062f\u0645 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 \u0641\u0642\u0637 \u0648\u064a\u0646\u062a\u0647\u064a \u0642\u0631\u064a\u0628\u0627\u064b.",
        confirmInfoTitle: "\u0643\u064a\u0641 \u064a\u062a\u0645 \u0627\u0644\u062d\u0630\u0641",
        confirmInfoBody:
            "\u0647\u0630\u0627 \u0627\u0644\u0637\u0644\u0628 \u064a\u062d\u0645\u0644 \u0631\u0627\u0628\u0637\u0627\u064b \u0628\u062a\u0648\u0643\u0646 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 \u0645\u0646 \u0627\u0644\u062a\u0637\u0628\u064a\u0642. \u0627\u0644\u062a\u0623\u0643\u064a\u062f \u064a\u0643\u0645\u0651\u0644 \u0627\u0644\u062d\u0630\u0641.",
        confirmButton: "\u062a\u0623\u0643\u064a\u062f \u062d\u0630\u0641 \u0627\u0644\u062d\u0633\u0627\u0628",
        invalidTitle: "\u0631\u0627\u0628\u0637 \u063a\u064a\u0631 \u0635\u062d\u064a\u062d",
        missingToken: "\u0631\u0627\u0645\u0632 \u0627\u0644\u062d\u0630\u0641 \u0645\u0641\u0642\u0648\u062f.",
        invalidOrExpired:
            "\u0631\u0627\u0628\u0637 \u0627\u0644\u062d\u0630\u0641 \u063a\u064a\u0631 \u0635\u062d\u064a\u062d \u0623\u0648 \u0645\u0646\u062a\u0647\u064a \u0627\u0644\u0635\u0644\u0627\u062d\u064a\u0629.",
        usedTitle: "\u062a\u0645 \u0627\u0633\u062a\u062e\u062f\u0627\u0645 \u0627\u0644\u0631\u0627\u0628\u0637",
        usedMessage: "\u062a\u0645 \u0627\u0633\u062a\u062e\u062f\u0627\u0645 \u0631\u0627\u0628\u0637 \u0627\u0644\u062d\u0630\u0641 \u0645\u0646 \u0642\u0628\u0644.",
        expiredTitle: "\u0627\u0646\u062a\u0647\u062a \u0635\u0644\u0627\u062d\u064a\u0629 \u0627\u0644\u0631\u0627\u0628\u0637",
        expiredMessage:
            "\u0627\u0646\u062a\u0647\u062a \u0635\u0644\u0627\u062d\u064a\u0629 \u0631\u0627\u0628\u0637 \u0627\u0644\u062d\u0630\u0641. \u064a\u0631\u062c\u0649 \u0637\u0644\u0628 \u0631\u0627\u0628\u0637 \u062c\u062f\u064a\u062f \u0645\u0646 \u0627\u0644\u062a\u0637\u0628\u064a\u0642.",
        successTitle: "\u062a\u0645 \u062d\u0630\u0641 \u0627\u0644\u062d\u0633\u0627\u0628",
        successMessage: "\u062a\u0645 \u062d\u0630\u0641 \u062d\u0633\u0627\u0628\u0643 \u0648\u0628\u064a\u0627\u0646\u0627\u062a\u0643 \u0628\u0646\u062c\u0627\u062d.",
        infoTitle: "\u062f\u0644\u064a\u0644 \u062d\u0630\u0641 \u0627\u0644\u062d\u0633\u0627\u0628",
        infoHeading: "\u0637\u0631\u064a\u0642\u0629 \u062d\u0630\u0641 \u0627\u0644\u062d\u0633\u0627\u0628",
        infoIntro:
            "\u0644\u0637\u0644\u0628 \u0627\u0644\u062d\u0630\u0641\u060c \u064a\u062c\u0628 \u0627\u0633\u062a\u062e\u062f\u0627\u0645 \u0627\u0644\u062a\u0637\u0628\u064a\u0642 \u0644\u0625\u0646\u0634\u0627\u0621 \u0631\u0627\u0628\u0637 \u0622\u0645\u0646 \u0645\u0624\u0642\u062a.",
        infoSteps:
            "\u0627\u0641\u062a\u062d \u0627\u0644\u062a\u0637\u0628\u064a\u0642 \u0648\u0627\u0630\u0647\u0628 \u0625\u0644\u0649 \u0627\u0644\u0628\u0631\u0648\u0641\u0627\u064a\u0644.\n\u0627\u0636\u063a\u0637 \u062d\u0630\u0641 \u0627\u0644\u062d\u0633\u0627\u0628.\n\u0623\u0643\u062f \u0644\u0641\u062a\u062d \u0635\u0641\u062d\u0629 \u0627\u0644\u062d\u0630\u0641 \u0627\u0644\u0622\u0645\u0646\u0629.\n\u0627\u0636\u063a\u0637 \u062a\u0623\u0643\u064a\u062f \u062d\u0630\u0641 \u0627\u0644\u062d\u0633\u0627\u0628 \u0644\u0644\u0625\u0646\u0647\u0627\u0621.",
        infoNote:
            "\u0631\u0627\u0628\u0637 \u0627\u0644\u062d\u0630\u0641 \u0645\u0624\u0642\u062a \u0648\u064a\u062a\u0645 \u0627\u0633\u062a\u062e\u062f\u0627\u0645\u0647 \u0645\u0631\u0629 \u0648\u0627\u062d\u062f\u0629 \u0641\u0642\u0637.",
        infoScreensIntro: "\u0627\u0644\u0635\u0648\u0631 \u0623\u062f\u0646\u0627\u0647 \u062a\u0648\u0636\u062d \u0627\u0644\u062e\u0637\u0648\u0627\u062a \u0628\u0627\u0644\u062a\u0631\u062a\u064a\u0628.",
        infoScreensHeading: "\u0627\u0644\u0634\u0631\u062d \u0628\u0627\u0644\u0635\u0648\u0631 \u062e\u0637\u0648\u0629 \u0628\u062e\u0637\u0648\u0629",
        infoStep1Title: "\u0627\u0644\u062e\u0637\u0648\u0629 1: \u0627\u0641\u062a\u062d \u0627\u0644\u0628\u0631\u0648\u0641\u0627\u064a\u0644",
        infoStep1Body: "\u0645\u0646 \u0627\u0644\u0634\u0627\u0634\u0629 \u0627\u0644\u0631\u0626\u064a\u0633\u064a\u0629\u060c \u0627\u0641\u062a\u062d \u0628\u0631\u0648\u0641\u0627\u064a\u0644\u0643 \u0644\u0644\u0648\u0635\u0648\u0644 \u0625\u0644\u0649 \u062e\u064a\u0627\u0631\u0627\u062a \u0627\u0644\u062d\u0633\u0627\u0628.",
        infoStep2Title: "\u0627\u0644\u062e\u0637\u0648\u0629 2: \u0627\u0636\u063a\u0637 \u062d\u0630\u0641 \u0627\u0644\u062d\u0633\u0627\u0628",
        infoStep2Body: "\u0627\u062e\u062a\u0631 \u062d\u0630\u0641 \u0627\u0644\u062d\u0633\u0627\u0628 \u0644\u0641\u062a\u062d \u0645\u0633\u0627\u0631 \u0627\u0644\u062d\u0630\u0641 \u0627\u0644\u0622\u0645\u0646.",
        infoStep3Title: "\u0627\u0644\u062e\u0637\u0648\u0629 3: \u062a\u0623\u0643\u064a\u062f \u0627\u0644\u062d\u0630\u0641",
        infoStep3Body: "\u0631\u0627\u062c\u0639 \u0627\u0644\u062a\u062d\u0630\u064a\u0631 \u062b\u0645 \u0627\u0636\u063a\u0637 \u062a\u0623\u0643\u064a\u062f \u062d\u0630\u0641 \u0627\u0644\u062d\u0633\u0627\u0628 \u0644\u0644\u0625\u0646\u0647\u0627\u0621.",
        infoActionTitle: "\u0637\u0644\u0628 \u0627\u0644\u062d\u0630\u0641",
        infoActionBody:
            "\u0625\u0630\u0627 \u0643\u0646\u062a \u0645\u0633\u062c\u0644\u0627\u064b\u060c \u064a\u0645\u0643\u0646\u0643 \u0637\u0644\u0628 \u0631\u0627\u0628\u0637 \u062d\u0630\u0641 \u0622\u0645\u0646 \u0627\u0644\u0622\u0646.",
        infoActionButton: "\u0637\u0644\u0628 \u0631\u0627\u0628\u0637 \u0627\u0644\u062d\u0630\u0641",
        infoMissingToken:
            "\u064a\u0631\u062c\u0649 \u062a\u0633\u062c\u064a\u0644 \u0627\u0644\u062f\u062e\u0648\u0644 \u0645\u0646 \u0627\u0644\u062a\u0637\u0628\u064a\u0642 \u0644\u0637\u0644\u0628 \u0631\u0627\u0628\u0637 \u0627\u0644\u062d\u0630\u0641. \u0647\u0630\u0647 \u0627\u0644\u0635\u0641\u062d\u0629 \u0644\u0648\u062d\u062f\u0647\u0627 \u0644\u0627 \u062a\u0633\u062a\u0637\u064a\u0639 \u0645\u0639\u0631\u0641\u0629 \u0647\u0648\u064a\u062a\u0643.",
        requestLinkTitle: "\u0627\u0644\u0631\u0627\u0628\u0637 \u062c\u0627\u0647\u0632",
        requestLinkBody: "\u0627\u0641\u062a\u062d \u0635\u0641\u062d\u0629 \u0627\u0644\u062d\u0630\u0641 \u0627\u0644\u0622\u0645\u0646\u0629 \u0645\u0646 \u0627\u0644\u0632\u0631 \u0628\u0627\u0644\u0623\u0633\u0641\u0644.",
        requestLinkButton: "\u0627\u0641\u062a\u062d \u0635\u0641\u062d\u0629 \u0627\u0644\u062d\u0630\u0641",
    },
};

const t = (locale, key) => {
    const copy = WEB_COPY[locale] || WEB_COPY.en;
    return copy[key] || WEB_COPY.en[key] || "";
};

const renderDeleteInfoPage = (locale, token, origin) => {
    const dir = locale === "ar" ? "rtl" : "ltr";
    const steps = t(locale, "infoSteps").split("\n");
    const stepsHtml = steps.map((step) => `<li>${step}</li>`).join("");
    const baseUrl = new URL("/delete-guide/", origin).toString().replace(/\/$/, "");
    const guideImages = [
        {
            src: `${baseUrl}/1.PNG`,
            alt: locale === "ar" ? "\u0627\u0644\u062e\u0637\u0648\u0629 1" : "Step 1",
            title: t(locale, "infoStep1Title"),
            body: t(locale, "infoStep1Body"),
        },
        {
            src: `${baseUrl}/2.PNG`,
            alt: locale === "ar" ? "\u0627\u0644\u062e\u0637\u0648\u0629 2" : "Step 2",
            title: t(locale, "infoStep2Title"),
            body: t(locale, "infoStep2Body"),
        },
        {
            src: `${baseUrl}/3.PNG`,
            alt: locale === "ar" ? "\u0627\u0644\u062e\u0637\u0648\u0629 3" : "Step 3",
            title: t(locale, "infoStep3Title"),
            body: t(locale, "infoStep3Body"),
        },
    ];
    const tokenSection = token
        ? `<div class="action">
            <h2>${t(locale, "infoActionTitle")}</h2>
            <p>${t(locale, "infoActionBody")}</p>
            <form method="post" action="/account/delete-request-web">
                <input type="hidden" name="token" value="${token}" />
                <button type="submit">${t(locale, "infoActionButton")}</button>
            </form>
        </div>`
        : `<div class="note">${t(locale, "infoMissingToken")}</div>`;
    return `<!doctype html>
    <html lang="${locale}" dir="${dir}">
        <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>${t(locale, "infoTitle")}</title>
            <style>
                body { font-family: Arial, sans-serif; background: #f6f7fb; color: #1b1f24; margin: 0; padding: 32px; }
                .card { max-width: 640px; margin: 0 auto; background: #ffffff; border-radius: 12px; padding: 24px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); }
                h1 { font-size: 22px; margin: 0 0 12px; }
                p { line-height: 1.6; }
                ul { padding-inline-start: 20px; line-height: 1.7; }
                .note { background: #f1f5f9; color: #0f172a; padding: 12px 14px; border-radius: 8px; margin-top: 16px; }
                .action { margin-top: 18px; padding: 16px; border-radius: 10px; background: #ecfdf3; color: #14532d; }
                .action h2 { font-size: 18px; margin: 0 0 8px; }
                .action button { margin-top: 10px; width: 100%; padding: 12px 16px; border: 0; border-radius: 10px; background: #16a34a; color: #ffffff; font-size: 16px; cursor: pointer; }
                .action button:hover { background: #15803d; }
                .guide { margin-top: 22px; }
                .guide h2 { font-size: 18px; margin: 0 0 10px; }
                .guide-item { display: flex; gap: 16px; padding: 14px; border-radius: 12px; border: 1px solid #e2e8f0; margin-top: 14px; align-items: flex-start; }
                .guide-item img { width: 100%; max-width: 220px; border-radius: 10px; border: 1px solid #e2e8f0; background: #f8fafc; }
                .guide-text h3 { font-size: 16px; margin: 0 0 6px; }
                .guide-text p { margin: 0; }
                @media (max-width: 640px) { .guide-item { flex-direction: column; } .guide-item img { max-width: 100%; } }
            </style>
        </head>
        <body>
            <div class="card">
                <h1>${t(locale, "infoHeading")}</h1>
                <p>${t(locale, "infoIntro")}</p>
                <ul>${stepsHtml}</ul>
                <div class="note">${t(locale, "infoNote")}</div>
                <div class="guide">
                    <h2>${t(locale, "infoScreensHeading")}</h2>
                    <p>${t(locale, "infoScreensIntro")}</p>
                    ${guideImages
            .map(
                (item, index) => `
                <div class="guide-item">
                    <img src="${item.src}" alt="${item.alt}" />
                    <div class="guide-text">
                        <h3>${index + 1}. ${item.title}</h3>
                        <p>${item.body}</p>
                    </div>
                </div>`,
            )
            .join("")}
                </div>
                ${tokenSection}
            </div>
        </body>
    </html>`;
};

const renderStatusPage = (locale, title, message) => {
    const dir = locale === "ar" ? "rtl" : "ltr";
    return `< !doctype html >
    <html lang="${locale}" dir="${dir}">
        <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>${title}</title>
            <style>
                body {font - family: Arial, sans-serif; background: #f6f7fb; color: #1b1f24; margin: 0; padding: 32px; }
                .card {max - width: 520px; margin: 0 auto; background: #ffffff; border-radius: 12px; padding: 24px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); }
                h1 {font - size: 22px; margin: 0 0 12px; }
                p {line - height: 1.5; }
            </style>
        </head>
        <body>
            <div class="card">
                <h1>${title}</h1>
                <p>${message}</p>
            </div>
        </body>
    </html>`;
};

const getConfigToken = (request) => {
    const authHeader = request.headers.get("authorization");
    if (authHeader) {
        const parts = authHeader.split(" ");
        if (parts.length === 2 && parts[0] === "Bearer") {
            return parts[1];
        }
    }
    return request.headers.get("x-config-token");
};

const isConfigAuthorized = (request, env) => {
    const token = getConfigToken(request);
    if (!token || !env.CONFIG_TOKEN) {
        return false;
    }
    return token === env.CONFIG_TOKEN;
};

const isR2Authorized = (request, env) => {
    const token = getConfigToken(request);
    if (!token || !env.R2_TOKEN) {
        return false;
    }
    return token === env.R2_TOKEN;
};

const getConfigPayload = async (env) => {
    const defaults = {
        update: "0",
        r2_account_id: "",
        r2_endpoint: "",
        r2_access_key_id: "",
        r2_secret_access_key: "",
        r2_bucket: "",
    };

    if (!env.CONFIG_KV) {
        return defaults;
    }

    const stored = await env.CONFIG_KV.get("remote_config", { type: "json" });
    if (!stored || typeof stored !== "object") {
        return defaults;
    }

    return { ...defaults, ...stored };
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

        if (path === "/r2/list" && request.method === "GET") {
            if (!env.BOOKS_BUCKET) {
                return jsonResponse({ error: "R2 not configured" }, 500);
            }
            if (!isR2Authorized(request, env)) {
                return unauthorized("Unauthorized");
            }
            const prefix = url.searchParams.get("prefix") || "";
            const cursor = url.searchParams.get("cursor") || undefined;
            const limitParam = url.searchParams.get("limit");
            const limit = limitParam ? Number(limitParam) : 1000;
            const list = await env.BOOKS_BUCKET.list({ prefix, cursor, limit });
            return jsonResponse({
                objects: list.objects.map((item) => ({
                    key: item.key,
                    size: item.size,
                    uploaded: item.uploaded,
                })),
                truncated: list.truncated,
                cursor: list.cursor,
            });
        }

        if (path === "/r2/get" && request.method === "GET") {
            if (!env.BOOKS_BUCKET) {
                return new Response("R2 not configured", { status: 500, headers: corsHeaders });
            }
            const key = url.searchParams.get("key");
            if (!key) {
                return new Response("Missing key", { status: 400, headers: corsHeaders });
            }
            const object = await env.BOOKS_BUCKET.get(key);
            if (!object) {
                return new Response("Not found", { status: 404, headers: corsHeaders });
            }
            return new Response(object.body, {
                status: 200,
                headers: {
                    "content-type": object.httpMetadata?.contentType || "application/octet-stream",
                    "etag": object.etag || "",
                    ...corsHeaders,
                },
            });
        }

        if (path === "/r2/put" && request.method === "PUT") {
            if (!env.BOOKS_BUCKET) {
                return jsonResponse({ error: "R2 not configured" }, 500);
            }
            if (!isR2Authorized(request, env)) {
                return unauthorized("Unauthorized");
            }
            const key = url.searchParams.get("key");
            if (!key) {
                return badRequest("Missing key");
            }
            if (!request.body) {
                return badRequest("Missing body");
            }
            const contentType = request.headers.get("content-type") || "application/octet-stream";
            await env.BOOKS_BUCKET.put(key, request.body, {
                httpMetadata: { contentType },
            });
            return jsonResponse({ ok: true, key });
        }

        if (path.startsWith("/delete-guide/")) {
            if (!env.ASSETS) {
                return new Response("Not found", { status: 404 });
            }
            return env.ASSETS.fetch(request);
        }

        if (path === "/config" && request.method === "GET") {
            if (!isConfigAuthorized(request, env)) {
                return unauthorized("Unauthorized");
            }
            const payload = await getConfigPayload(env);
            return jsonResponse(payload);
        }

        if (path === "/account/delete-info" && request.method === "GET") {
            const locale = getPreferredLocale(request);
            const token = url.searchParams.get("token");
            return htmlResponse(renderDeleteInfoPage(locale, token, url.origin));
        }

        if (path === "/account/delete-request-web" && request.method === "POST") {
            const locale = getPreferredLocale(request);
            const form = await parseFormBody(request);
            const token = form.get("token");
            if (!token) {
                return htmlResponse(
                    renderStatusPage(
                        locale,
                        t(locale, "invalidTitle"),
                        t(locale, "missingToken"),
                    ),
                    400,
                );
            }

            const user = await verifyJwt(token, env.JWT_SECRET);
            if (!user) {
                return htmlResponse(
                    renderStatusPage(
                        locale,
                        t(locale, "invalidTitle"),
                        t(locale, "invalidOrExpired"),
                    ),
                    401,
                );
            }

            const now = Date.now();
            const oneTimeToken = generateOneTimeToken();
            const tokenHash = await sha256Hex(oneTimeToken);
            const expiresAt = now + 30 * 60 * 1000;

            await env.DB.prepare(
                "DELETE FROM account_deletion_tokens WHERE user_id = ?",
            )
                .bind(user.sub)
                .run();

            await env.DB.prepare(
                "INSERT INTO account_deletion_tokens (token_hash, user_id, created_at, expires_at, used_at) VALUES (?, ?, ?, ?, NULL)",
            )
                .bind(tokenHash, user.sub, now, expiresAt)
                .run();

            const origin = new URL(request.url).origin;
            const deleteUrl = new URL("/account/delete", origin);
            deleteUrl.searchParams.set("token", oneTimeToken);

            const dir = locale === "ar" ? "rtl" : "ltr";
            return htmlResponse(
                `< !doctype html >
    <html lang="${locale}" dir="${dir}">
        <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>${t(locale, "requestLinkTitle")}</title>
            <style>
                body {font - family: Arial, sans-serif; background: #f6f7fb; color: #1b1f24; margin: 0; padding: 32px; }
                .card {max - width: 520px; margin: 0 auto; background: #ffffff; border-radius: 12px; padding: 24px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); }
                h1 {font - size: 22px; margin: 0 0 12px; }
                p {line - height: 1.5; }
                a.button {display: block; text-align: center; text-decoration: none; padding: 12px 16px; border-radius: 10px; background: #dc2626; color: #ffffff; font-size: 16px; }
                a.button:hover {background: #b91c1c; }
            </style>
        </head>
        <body>
            <div class="card">
                <h1>${t(locale, "requestLinkTitle")}</h1>
                <p>${t(locale, "requestLinkBody")}</p>
                <a class="button" href="${deleteUrl.toString()}">${t(locale, "requestLinkButton")}</a>
            </div>
        </body>
    </html>`,
            );
        }

        if (path === "/developer/requests" && request.method === "POST") {
            const user = await getAuthUser(request, env);
            if (!user) {
                return unauthorized("Unauthorized");
            }
            const body = await parseJsonBody(request);
            if (!body) {
                return badRequest("Invalid JSON");
            }
            const { phone, data } = body;
            if (!phone || !data) {
                return badRequest("Missing required fields");
            }

            const id = crypto.randomUUID();
            const now = Date.now();
            await env.DB.prepare(
                "INSERT INTO edit_requests (id, phone, payload, created_at, created_by) VALUES (?, ?, ?, ?, ?)",
            )
                .bind(id, phone, JSON.stringify(data), now, user.sub)
                .run();

            return jsonResponse({ ok: true, id });
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
                "SELECT id, name, email, phone, password_hash, password_salt, is_active, is_admin FROM users WHERE phone = ? LIMIT 1",
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
                    is_admin: user.is_admin === 1,
                    exp: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 30,
                },
                env.JWT_SECRET,
            );

            return jsonResponse({
                token,
                user: { id: user.id, name: user.name, email: user.email, phone: user.phone, is_admin: user.is_admin === 1 },
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

        if (path === "/account/delete-request" && request.method === "POST") {
            const user = await getAuthUser(request, env);
            if (!user) {
                return unauthorized("Unauthorized");
            }

            // Delete all user-related data
            await env.DB.prepare("DELETE FROM donors WHERE created_by = ?")
                .bind(user.sub)
                .run();
            await env.DB.prepare("DELETE FROM doctors WHERE created_by = ?")
                .bind(user.sub)
                .run();
            await env.DB.prepare("DELETE FROM professions WHERE created_by = ?")
                .bind(user.sub)
                .run();
            await env.DB.prepare("DELETE FROM cars WHERE created_by = ?")
                .bind(user.sub)
                .run();
            await env.DB.prepare("DELETE FROM satota WHERE created_by = ?")
                .bind(user.sub)
                .run();
            await env.DB.prepare("DELETE FROM edit_requests WHERE created_by = ?")
                .bind(user.sub)
                .run();
            await env.DB.prepare("DELETE FROM account_deletion_tokens WHERE user_id = ?")
                .bind(user.sub)
                .run();
            await env.DB.prepare("DELETE FROM account_delete_email_otp WHERE user_id = ?")
                .bind(user.sub)
                .run();
            await env.DB.prepare("DELETE FROM users WHERE id = ?")
                .bind(user.sub)
                .run();

            return jsonResponse({ ok: true, deleted: true });
        }

        if (path === "/account/delete-email-otp/request" && request.method === "POST") {
            return jsonResponse({ error: "Account deletion by email OTP is disabled." }, 400);
        }

        if (path === "/account/delete-email-otp/verify" && request.method === "POST") {
            return jsonResponse({ error: "Account deletion by email OTP is disabled." }, 400);
        }

        if (path === "/account/delete" && request.method === "GET") {
            const locale = getPreferredLocale(request);
            const token = url.searchParams.get("token");
            if (!token) {
                return htmlResponse(
                    renderStatusPage(
                        locale,
                        t(locale, "invalidTitle"),
                        t(locale, "missingToken"),
                    ),
                    400,
                );
            }

            const tokenHash = await sha256Hex(token);
            const record = await env.DB.prepare(
                "SELECT user_id, expires_at, used_at FROM account_deletion_tokens WHERE token_hash = ? LIMIT 1",
            )
                .bind(tokenHash)
                .first();

            if (!record) {
                return htmlResponse(
                    renderStatusPage(
                        locale,
                        t(locale, "invalidTitle"),
                        t(locale, "invalidOrExpired"),
                    ),
                    410,
                );
            }

            const expiresAt = Number(record.expires_at) || 0;
            if (record.used_at) {
                return htmlResponse(
                    renderStatusPage(
                        locale,
                        t(locale, "usedTitle"),
                        t(locale, "usedMessage"),
                    ),
                    410,
                );
            }

            if (expiresAt < Date.now()) {
                return htmlResponse(
                    renderStatusPage(
                        locale,
                        t(locale, "expiredTitle"),
                        t(locale, "expiredMessage"),
                    ),
                    410,
                );
            }

            return htmlResponse(renderDeletePage(token, locale));
        }

        if (path === "/account/delete/confirm" && request.method === "POST") {
            const locale = getPreferredLocale(request);
            const form = await parseFormBody(request);
            const token = form.get("token");
            if (!token) {
                return htmlResponse(
                    renderStatusPage(
                        locale,
                        t(locale, "invalidTitle"),
                        t(locale, "missingToken"),
                    ),
                    400,
                );
            }

            const tokenHash = await sha256Hex(token);
            const record = await env.DB.prepare(
                "SELECT user_id, expires_at, used_at FROM account_deletion_tokens WHERE token_hash = ? LIMIT 1",
            )
                .bind(tokenHash)
                .first();

            if (!record) {
                return htmlResponse(
                    renderStatusPage(
                        locale,
                        t(locale, "invalidTitle"),
                        t(locale, "invalidOrExpired"),
                    ),
                    410,
                );
            }

            const expiresAt = Number(record.expires_at) || 0;
            if (record.used_at) {
                return htmlResponse(
                    renderStatusPage(
                        locale,
                        t(locale, "usedTitle"),
                        t(locale, "usedMessage"),
                    ),
                    410,
                );
            }

            if (expiresAt < Date.now()) {
                return htmlResponse(
                    renderStatusPage(
                        locale,
                        t(locale, "expiredTitle"),
                        t(locale, "expiredMessage"),
                    ),
                    410,
                );
            }

            const userId = record.user_id;
            await env.DB.prepare("DELETE FROM donors WHERE created_by = ?")
                .bind(userId)
                .run();
            await env.DB.prepare("DELETE FROM doctors WHERE created_by = ?")
                .bind(userId)
                .run();
            await env.DB.prepare("DELETE FROM professions WHERE created_by = ?")
                .bind(userId)
                .run();
            await env.DB.prepare("DELETE FROM cars WHERE created_by = ?")
                .bind(userId)
                .run();
            await env.DB.prepare("DELETE FROM satota WHERE created_by = ?")
                .bind(userId)
                .run();
            await env.DB.prepare("DELETE FROM edit_requests WHERE created_by = ?")
                .bind(userId)
                .run();
            await env.DB.prepare("DELETE FROM users WHERE id = ?")
                .bind(userId)
                .run();

            await env.DB.prepare(
                "UPDATE account_deletion_tokens SET used_at = ? WHERE token_hash = ?",
            )
                .bind(Date.now(), tokenHash)
                .run();

            return htmlResponse(
                renderStatusPage(
                    locale,
                    t(locale, "successTitle"),
                    t(locale, "successMessage"),
                ),
            );
        }

        if (path === "/donors" && request.method === "GET") {
            const user = await getAuthUser(request, env);
            const bloodType = url.searchParams.get("bloodType");
            const number = url.searchParams.get("number");
            const { limit, offset } = parsePagination(url);
            let query = "SELECT id, name, phone AS number, location, blood_type AS type, CASE WHEN created_by = ? THEN 1 ELSE 0 END AS canManage FROM donors WHERE is_active = 1";
            const params = [];
            params.push(user?.sub || "");
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
            const user = await getAuthUser(request, env);
            const { limit, offset } = parsePagination(url);
            const result = await env.DB.prepare(
                "SELECT id, name, phone AS number, specialization, presence, title, CASE WHEN created_by = ? THEN 1 ELSE 0 END AS canManage FROM doctors WHERE is_active = 1 ORDER BY created_at DESC LIMIT ? OFFSET ?",
            )
                .bind(user?.sub || "", limit, offset)
                .all();
            return jsonResponse(result.results || []);
        }

        if (path === "/professions" && request.method === "GET") {
            const user = await getAuthUser(request, env);
            const { limit, offset } = parsePagination(url);
            const result = await env.DB.prepare(
                "SELECT id, name, phone AS number, name_profession AS nameProfession, CASE WHEN created_by = ? THEN 1 ELSE 0 END AS canManage FROM professions WHERE is_active = 1 ORDER BY created_at DESC LIMIT ? OFFSET ?",
            )
                .bind(user?.sub || "", limit, offset)
                .all();
            return jsonResponse(result.results || []);
        }

        if (path === "/cars" && request.method === "GET") {
            const user = await getAuthUser(request, env);
            const { limit, offset } = parsePagination(url);
            const result = await env.DB.prepare(
                "SELECT id, name, phone AS number, vehicle_type AS type, time, route_from AS 'from', CASE WHEN created_by = ? THEN 1 ELSE 0 END AS canManage FROM cars WHERE is_active = 1 ORDER BY created_at DESC LIMIT ? OFFSET ?",
            )
                .bind(user?.sub || "", limit, offset)
                .all();
            return jsonResponse(result.results || []);
        }

        if (path === "/satota" && request.method === "GET") {
            const user = await getAuthUser(request, env);
            const { limit, offset } = parsePagination(url);
            const result = await env.DB.prepare(
                "SELECT id, name, phone AS number, location, CASE WHEN created_by = ? THEN 1 ELSE 0 END AS canManage FROM satota WHERE is_active = 1 ORDER BY created_at DESC LIMIT ? OFFSET ?",
            )
                .bind(user?.sub || "", limit, offset)
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

            // المطور يمكنه حذف أي عنصر
            let canDelete = false;
            if (user.is_admin === true || user.email === "amhmeed31@gmail.com" || user.phone === "07824854525") {
                canDelete = true;
            } else {
                const owned = await env.DB.prepare(`SELECT id FROM ${table} WHERE id = ? AND created_by = ? LIMIT 1`)
                    .bind(id, user.sub)
                    .first();
                if (owned) canDelete = true;
            }
            if (!canDelete) {
                return jsonResponse({ error: "Forbidden: owner only" }, 403);
            }
            await env.DB.prepare(`DELETE FROM ${table} WHERE id = ?`)
                .bind(id)
                .run();
            return jsonResponse({ ok: true });
        }

        if (path === "/items" && request.method === "PUT") {
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

            const body = await parseJsonBody(request);
            if (!body) {
                return badRequest("Invalid JSON");
            }

            const mappedPayload = mapUpdatePayload(type, body);
            const editableColumns = getEditableColumns(type);
            const assignments = [];
            const values = [];
            for (const column of editableColumns) {
                const value = mappedPayload[column];
                if (typeof value === "string") {
                    const trimmed = value.trim();
                    if (!trimmed) {
                        return badRequest(`Missing or empty field: ${column}`);
                    }
                    assignments.push(`${column} = ?`);
                    values.push(trimmed);
                }
            }

            if (!assignments.length) {
                return badRequest("No editable fields provided");
            }

            // المطور يمكنه التعديل على أي عنصر
            let canEdit = false;
            if (user.is_admin === true || user.email === "amhmeed31@gmail.com" || user.phone === "07824854525") {
                canEdit = true;
            } else {
                const owned = await env.DB.prepare(`SELECT id FROM ${table} WHERE id = ? AND created_by = ? LIMIT 1`)
                    .bind(id, user.sub)
                    .first();
                if (owned) canEdit = true;
            }
            if (!canEdit) {
                return jsonResponse({ error: "Forbidden: owner only" }, 403);
            }
            const sql = `UPDATE ${table} SET ${assignments.join(", ")} WHERE id = ?`;
            await env.DB.prepare(sql)
                .bind(...values, id)
                .run();
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
            if (phone !== user.phone) {
                return jsonResponse({ error: "Forbidden: owner only" }, 403);
            }
            await env.DB.prepare("DELETE FROM users WHERE id = ? AND phone = ?")
                .bind(user.sub, phone)
                .run();
            return jsonResponse({ ok: true });
        }

        return jsonResponse({ error: "Not found" }, 404);
    },
};

