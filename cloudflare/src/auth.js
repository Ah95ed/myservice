import {
    badRequest,
    generateOtpCode,
    hashPassword,
    jsonResponse,
    normalizeEmail,
    parseJsonBody,
    sendOtpEmail,
    signJwt,
    unauthorized,
    validateAuthInput,
    verifyPassword,
} from "./utils.js";

export const handleAuthRoutes = async (request, env, path) => {
  if (path === "/auth/signup/request" && request.method === "POST") {
    const body = await parseJsonBody(request);
    if (!body || !body.email || !body.phone)
      return badRequest("البريد الإلكتروني ورقم الهاتف مطلوبان");

    const normalizedEmail = normalizeEmail(body.email);
    const trimmedPhone = body.phone.trim();

    try {
      const existingUser = await env.DB.prepare(
        "SELECT id FROM users WHERE email = ? OR phone = ? LIMIT 1",
      )
        .bind(normalizedEmail, trimmedPhone)
        .first();

      if (existingUser) {
        return jsonResponse({
          ok: true,
          message: "إذا كان البريد أو الهاتف غير مسجل، فستصلك رسالة",
        });
      }

      const otp = env.RESEND_API_KEY ? generateOtpCode() : "000000";
      const expiresAt = Date.now() + 10 * 60 * 1000;

      await env.DB.prepare(
        "DELETE FROM signup_otps WHERE email = ? OR phone = ?",
      )
        .bind(normalizedEmail, trimmedPhone)
        .run();
      await env.DB.prepare(
        "INSERT INTO signup_otps (email, phone, code, expires_at, created_at) VALUES (?, ?, ?, ?, ?)",
      )
        .bind(normalizedEmail, trimmedPhone, otp, expiresAt, Date.now())
        .run();

      try {
        await sendOtpEmail(
          env,
          normalizedEmail,
          otp,
          "رمز التحقق للتسجيل",
          "تأكيد التسجيل",
        );
      } catch (mailError) {
        console.error("Mail Error:", mailError);
        return jsonResponse(
          { error: "فشل إرسال بريد التحقق", details: mailError.message },
          500,
        );
      }
      return jsonResponse({ ok: true });
    } catch (e) {
      return jsonResponse({ error: "Database Error", details: e.message }, 500);
    }
  }

  if (path === "/auth/register" && request.method === "POST") {
    const body = await parseJsonBody(request);
    if (!body) return badRequest("بيانات غير صالحة");

    const validationErrors = validateAuthInput(body, "register");
    if (validationErrors.length > 0)
      return badRequest(validationErrors.join(", "));

    const { name, email, phone, password, is_admin, otp } = body;
    if (!otp) return badRequest("رمز التحقق مطلوب");

    const normalizedEmail = normalizeEmail(email);
    const trimmedPhone = phone.trim();

    const record = await env.DB.prepare(
      "SELECT * FROM signup_otps WHERE email = ? AND phone = ? AND code = ? LIMIT 1",
    )
      .bind(normalizedEmail, trimmedPhone, otp)
      .first();
    if (!record || Date.now() > record.expires_at)
      return badRequest("رمز التحقق غير صحيح أو منتهي");

    const trimmedPassword = password.trim();

    const existing = await env.DB.prepare(
      "SELECT id FROM users WHERE email = ? OR phone = ? LIMIT 1",
    )
      .bind(normalizedEmail, trimmedPhone)
      .first();

    if (existing)
      return badRequest("المستخدم موجود مسبقاً (البريد أو الهاتف مستخدم)");

    const now = Date.now();
    const { hash, salt } = await hashPassword(trimmedPassword);
    const userId = crypto.randomUUID();

    await env.DB.prepare(
      "INSERT INTO users (id, name, email, phone, password_hash, password_salt, created_at, last_login, is_active, is_admin) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1, ?)",
    )
      .bind(
        userId,
        name.trim(),
        normalizedEmail,
        trimmedPhone,
        hash,
        salt,
        now,
        now,
        is_admin || 0,
      )
      .run();

    const token = await signJwt(
      {
        sub: userId,
        email: normalizedEmail,
        phone: trimmedPhone,
        name: name.trim(),
        is_admin: is_admin === 1,
        exp: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 30,
      },
      env.JWT_SECRET,
    );

    return jsonResponse({
      token,
      user: { id: userId, name, email: normalizedEmail, phone: trimmedPhone },
    });
  }

  if (path === "/auth/login" && request.method === "POST") {
    const body = await parseJsonBody(request);
    if (!body) return badRequest("بيانات غير صالحة");

    const { phone, password } = body;
    if (!phone || !password)
      return badRequest("يرجى إدخال الهاتف وكلمة المرور");

    const trimmedPhone = phone.trim();
    const trimmedPassword = password.trim();

    const user = await env.DB.prepare(
      "SELECT * FROM users WHERE phone = ? LIMIT 1",
    )
      .bind(trimmedPhone)
      .first();

    if (!user) return unauthorized("رقم الهاتف غير مسجل");
    if (user.is_active !== 1) return unauthorized("الحساب معطل حالياً");

    const isValid = await verifyPassword(
      trimmedPassword,
      user.password_salt,
      user.password_hash,
    );
    if (!isValid) return unauthorized("كلمة المرور غير صحيحة");

    await env.DB.prepare("UPDATE users SET last_login = ? WHERE id = ?")
      .bind(Date.now(), user.id)
      .run();

    const token = await signJwt(
      {
        sub: user.id,
        email: user.email,
        phone: user.phone,
        name: user.name,
        is_admin: user.is_admin === 1,
        exp: Math.floor(Date.now() / 1000) + 60 * 60 * 24 * 30,
      },
      env.JWT_SECRET,
    );

    return jsonResponse({
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        is_admin: user.is_admin === 1,
      },
    });
  }

  if (path === "/auth/reset-password/request" && request.method === "POST") {
    const body = await parseJsonBody(request);
    if (!body || !body.email) return badRequest("البريد الإلكتروني مطلوب");

    const normalizedEmail = normalizeEmail(body.email);
    const user = await env.DB.prepare(
      "SELECT id FROM users WHERE email = ? LIMIT 1",
    )
      .bind(normalizedEmail)
      .first();

    if (!user) {
      return jsonResponse({
        ok: true,
        message: "إذا كان البريد مسجلاً، فستصلك رسالة",
      });
    }

    const otp = env.RESEND_API_KEY ? generateOtpCode() : "000000";
    const expiresAt = Date.now() + 10 * 60 * 1000;

    try {
      await env.DB.prepare("DELETE FROM password_reset_otps WHERE email = ?")
        .bind(normalizedEmail)
        .run();
      await env.DB.prepare(
        "INSERT INTO password_reset_otps (email, code, expires_at, created_at) VALUES (?, ?, ?, ?)",
      )
        .bind(normalizedEmail, otp, expiresAt, Date.now())
        .run();

      try {
        await sendOtpEmail(
          env,
          normalizedEmail,
          otp,
          "رمز إعادة تعيين كلمة المرور",
          "استعادة الحساب",
        );
      } catch (mailError) {
        console.error("Mail Error:", mailError);
        return jsonResponse(
          {
            error: "فشل إرسال بريد استعادة الحساب",
            details: mailError.message,
          },
          500,
        );
      }
      return jsonResponse({ ok: true });
    } catch (dbError) {
      return jsonResponse(
        { error: "Database Error", details: dbError.message },
        500,
      );
    }
  }

  if (path === "/auth/reset-password/confirm" && request.method === "POST") {
    const body = await parseJsonBody(request);
    if (!body) return badRequest("بيانات غير صالحة");
    const { email, otp, newPassword } = body;

    if (!email || !otp || !newPassword || newPassword.length < 6) {
      return badRequest(
        "يرجى إدخال جميع البيانات بشكل صحيح (كلمة المرور 6 أحرف على الأقل)",
      );
    }

    const normalizedEmail = normalizeEmail(email);
    const record = await env.DB.prepare(
      "SELECT * FROM password_reset_otps WHERE email = ? AND code = ? LIMIT 1",
    )
      .bind(normalizedEmail, otp)
      .first();

    if (!record || Date.now() > record.expires_at) {
      return badRequest("الرمز غير صحيح أو انتهت صلاحيته");
    }

    const { hash, salt } = await hashPassword(newPassword.trim());
    const result = await env.DB.prepare(
      "UPDATE users SET password_hash = ?, password_salt = ? WHERE email = ?",
    )
      .bind(hash, salt, normalizedEmail)
      .run();

    if (!result.meta.changes) {
      return badRequest("لم يتم العثور على حساب بهذا البريد الإلكتروني");
    }

    await env.DB.prepare("DELETE FROM password_reset_otps WHERE email = ?")
      .bind(normalizedEmail)
      .run();

    return jsonResponse({ ok: true });
  }

  return null;
};
