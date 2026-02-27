import {
    badRequest,
    getAuthUser,
    getConfigPayload,
    isConfigAuthorized,
    jsonResponse,
    parseJsonBody,
    unauthorized,
} from "./utils.js";

export const handleMiscRoutes = async (request, env, path, url) => {
  if (path === "/health") {
    return jsonResponse({ ok: true, app: env.APP_NAME || "app" });
  }

  if (path === "/config" && request.method === "GET") {
    if (!isConfigAuthorized(request, env)) {
      return unauthorized("Unauthorized");
    }
    const payload = await getConfigPayload(env);
    return jsonResponse(payload);
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

  if (path.startsWith("/delete-guide/")) {
    if (!env.ASSETS) {
      return new Response("Not found", { status: 404 });
    }
    return env.ASSETS.fetch(request);
  }

  return null;
};
