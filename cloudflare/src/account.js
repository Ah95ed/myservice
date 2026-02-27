import {
    renderDeleteInfoPage,
    renderDeletePage,
    renderStatusPage,
    t,
} from "./templates.js";
import {
    badRequest,
    generateOneTimeToken,
    getAuthUser,
    getPreferredLocale,
    htmlResponse,
    jsonResponse,
    parseFormBody,
    sha256Hex,
    unauthorized,
    verifyJwt,
} from "./utils.js";

export const handleAccountRoutes = async (request, env, path, url) => {
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
      `<!doctype html>
    <html lang="${locale}" dir="${dir}">
        <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>${t(locale, "requestLinkTitle")}</title>
            <style>
                body {font-family: Arial, sans-serif; background: #f6f7fb; color: #1b1f24; margin: 0; padding: 32px; }
                .card {max-width: 520px; margin: 0 auto; background: #ffffff; border-radius: 12px; padding: 24px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); }
                h1 {font-size: 22px; margin: 0 0 12px; }
                p {line-height: 1.5; }
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

  if (path === "/account/delete-request" && request.method === "POST") {
    const user = await getAuthUser(request, env);
    if (!user) {
      return unauthorized("Unauthorized");
    }

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
    await env.DB.prepare(
      "DELETE FROM account_deletion_tokens WHERE user_id = ?",
    )
      .bind(user.sub)
      .run();
    await env.DB.prepare(
      "DELETE FROM account_delete_email_otp WHERE user_id = ?",
    )
      .bind(user.sub)
      .run();
    await env.DB.prepare("DELETE FROM users WHERE id = ?").bind(user.sub).run();

    return jsonResponse({ ok: true, deleted: true, url: "" });
  }

  if (
    path === "/account/delete-email-otp/request" &&
    request.method === "POST"
  ) {
    return jsonResponse(
      { error: "Account deletion by email OTP is disabled." },
      400,
    );
  }

  if (
    path === "/account/delete-email-otp/verify" &&
    request.method === "POST"
  ) {
    return jsonResponse(
      { error: "Account deletion by email OTP is disabled." },
      400,
    );
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
    await env.DB.prepare("DELETE FROM users WHERE id = ?").bind(userId).run();

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

  return null;
};
