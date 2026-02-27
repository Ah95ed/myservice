export const WEB_COPY = {
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
    expiredMessage:
      "This deletion link has expired. Please request a new one from the app.",
    successTitle: "Account deleted",
    successMessage: "Your account and data have been deleted successfully.",
    infoTitle: "Delete account guide",
    infoHeading: "How to delete your account",
    infoIntro:
      "To request deletion, you must use the app so we can generate a secure one-time link.",
    infoSteps:
      "Open the app and go to Profile.\nTap Delete Account.\nConfirm to open the secure deletion page.\nPress Confirm delete account to finish.",
    infoNote: "The deletion link expires quickly and can only be used once.",
    infoScreensIntro: "Screenshots below show the exact flow in order.",
    infoScreensHeading: "Step-by-step screenshots",
    infoStep1Title: "Step 1: Open Profile",
    infoStep1Body:
      "From the main screen, open your profile to access account actions.",
    infoStep2Title: "Step 2: Tap Delete Account",
    infoStep2Body: "Select Delete Account to open the secure deletion flow.",
    infoStep3Title: "Step 3: Confirm deletion",
    infoStep3Body:
      "Review the warning and press Confirm delete account to finish.",
    infoActionTitle: "Request deletion",
    infoActionBody:
      "If you are signed in, you can request a secure deletion link now.",
    infoActionButton: "Request delete link",
    infoMissingToken:
      "Sign in through the app to request a deletion link. This page alone cannot identify you.",
    requestLinkTitle: "Deletion link ready",
    requestLinkBody: "Open the secure deletion page using the button below.",
    requestLinkButton: "Open delete page",
  },
  ar: {
    confirmTitle: "تأكيد حذف الحساب",
    confirmHeading: "تأكيد حذف الحساب",
    confirmBody: "سيتم حذف الحساب والبيانات نهائياً. لن تتمكن من استرجاعها.",
    confirmWarning: "هذا الرابط يستخدم مرة واحدة فقط وينتهي قريباً.",
    confirmInfoTitle: "كيف يتم الحذف",
    confirmInfoBody:
      "هذا الطلب يحمل رابطاً بتوكن مرة واحدة من التطبيق. التأكيد يكمّل الحذف.",
    confirmButton: "تأكيد حذف الحساب",
    invalidTitle: "رابط غير صحيح",
    missingToken: "رامز الحذف مفقود.",
    invalidOrExpired: "رابط الحذف غير صحيح أو منتهي الصلاحية.",
    usedTitle: "تم استخدام الرابط",
    usedMessage: "تم استخدام رابط الحذف من قبل.",
    expiredTitle: "انتهت صلاحية الرابط",
    expiredMessage: "انتهت صلاحية رابط الحذف. يرجى طلب رابط جديد من التطبيق.",
    successTitle: "تم حذف الحساب",
    successMessage: "تم حذف حسابك وبياناتك بنجاح.",
    infoTitle: "دليل حذف الحساب",
    infoHeading: "طريقة حذف الحساب",
    infoIntro: "لطلب الحذف، يجب استخدام التطبيق لإنشاء رابط آمن مؤقت.",
    infoSteps:
      "افتح التطبيق واذهب إلى البروفايل.\nاضغط حذف الحساب.\nأكد لفتح صفحة الحذف الآمنة.\nاضغط تأكيد حذف الحساب للإنهاء.",
    infoNote: "رابط الحذف مؤقت ويتم استخدامه مرة واحدة فقط.",
    infoScreensIntro: "الصور أدناه توضح الخطوات بالترتيب.",
    infoScreensHeading: "الشرح بالصور خطوة بخطوة",
    infoStep1Title: "الخطوة 1: افتح البروفايل",
    infoStep1Body:
      "من الشاشة الرئيسية، افتح بروفايلك للوصول إلى خيارات الحساب.",
    infoStep2Title: "الخطوة 2: اضغط حذف الحساب",
    infoStep2Body: "اختر حذف الحساب لفتح مسار الحذف الآمن.",
    infoStep3Title: "الخطوة 3: تأكيد الحذف",
    infoStep3Body: "راجع التحذير ثم اضغط تأكيد حذف الحساب للإنهاء.",
    infoActionTitle: "طلب الحذف",
    infoActionBody: "إذا كنت مسجلاً، يمكنك طلب رابط حذف آمن الآن.",
    infoActionButton: "طلب رابط الحذف",
    infoMissingToken:
      "يرجى تسجيل الدخول من التطبيق لطلب رابط الحذف. هذه الصفحة لوحدها لا تستطيع معرفة هويتك.",
    requestLinkTitle: "الرابط جاهز",
    requestLinkBody: "افتح صفحة الحذف الآمنة من الزر بالأسفل.",
    requestLinkButton: "افتح صفحة الحذف",
  },
};

export const t = (locale, key) => {
  const copy = WEB_COPY[locale] || WEB_COPY.en;
  return copy[key] || WEB_COPY.en[key] || "";
};

export const renderDeleteInfoPage = (locale, token, origin) => {
  const dir = locale === "ar" ? "rtl" : "ltr";
  const steps = t(locale, "infoSteps").split("\n");
  const stepsHtml = steps.map((step) => `<li>${step}</li>`).join("");
  const baseUrl = new URL("/delete-guide/", origin)
    .toString()
    .replace(/\/$/, "");
  const guideImages = [
    {
      src: `${baseUrl}/1.PNG`,
      alt: locale === "ar" ? "الخطوة 1" : "Step 1",
      title: t(locale, "infoStep1Title"),
      body: t(locale, "infoStep1Body"),
    },
    {
      src: `${baseUrl}/2.PNG`,
      alt: locale === "ar" ? "الخطوة 2" : "Step 2",
      title: t(locale, "infoStep2Title"),
      body: t(locale, "infoStep2Body"),
    },
    {
      src: `${baseUrl}/3.PNG`,
      alt: locale === "ar" ? "الخطوة 3" : "Step 3",
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

export const renderStatusPage = (locale, title, message) => {
  const dir = locale === "ar" ? "rtl" : "ltr";
  return `<!doctype html>
    <html lang="${locale}" dir="${dir}">
        <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>${title}</title>
            <style>
                body {font-family: Arial, sans-serif; background: #f6f7fb; color: #1b1f24; margin: 0; padding: 32px; }
                .card {max-width: 520px; margin: 0 auto; background: #ffffff; border-radius: 12px; padding: 24px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); }
                h1 {font-size: 22px; margin: 0 0 12px; }
                p {line-height: 1.5; }
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

export const renderDeletePage = (token, locale) => {
  const dir = locale === "ar" ? "rtl" : "ltr";
  return `<!doctype html>
    <html lang="${locale}" dir="${dir}">
        <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>${t(locale, "confirmTitle")}</title>
            <style>
                body { font-family: Arial, sans-serif; background: #f6f7fb; color: #1b1f24; margin: 0; padding: 32px; }
                .card { max-width: 520px; margin: 0 auto; background: #ffffff; border-radius: 12px; padding: 24px; box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08); }
                h1 { font-size: 22px; margin: 0 0 12px; }
                p { line-height: 1.5; }
                form { margin-top: 18px; }
                button { width: 100%; padding: 12px 16px; border: 0; border-radius: 10px; background: #dc2626; color: #ffffff; font-size: 16px; cursor: pointer; }
                button:hover { background: #b91c1c; }
            </style>
        </head>
        <body>
            <div class="card">
                <h1>${t(locale, "confirmHeading")}</h1>
                <p>${t(locale, "confirmBody")}</p>
                <form method="post" action="/account/delete/confirm">
                    <input type="hidden" name="token" value="${token}" />
                    <button type="submit">${t(locale, "confirmButton")}</button>
                </form>
            </div>
        </body>
    </html>`;
};
