import { isR2Authorized, jsonResponse, unauthorized } from "./utils.js";

export const handleR2Routes = async (request, env, path, url) => {
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
      return new Response("R2 not configured", {
        status: 500,
        headers: {
          "access-control-allow-origin": "*",
          "access-control-allow-methods": "GET,POST,PUT,DELETE,OPTIONS",
          "access-control-allow-headers":
            "content-type,authorization,x-migration-token",
        },
      });
    }
    const key = url.searchParams.get("key");
    if (!key) {
      return new Response("Missing key", {
        status: 400,
        headers: {
          "access-control-allow-origin": "*",
          "access-control-allow-methods": "GET,POST,PUT,DELETE,OPTIONS",
          "access-control-allow-headers":
            "content-type,authorization,x-migration-token",
        },
      });
    }
    const object = await env.BOOKS_BUCKET.get(key);
    if (!object) {
      return new Response("Not found", {
        status: 404,
        headers: {
          "access-control-allow-origin": "*",
          "access-control-allow-methods": "GET,POST,PUT,DELETE,OPTIONS",
          "access-control-allow-headers":
            "content-type,authorization,x-migration-token",
        },
      });
    }
    return new Response(object.body, {
      status: 200,
      headers: {
        "content-type":
          object.httpMetadata?.contentType || "application/octet-stream",
        etag: object.etag || "",
        "access-control-allow-origin": "*",
        "access-control-allow-methods": "GET,POST,PUT,DELETE,OPTIONS",
        "access-control-allow-headers":
          "content-type,authorization,x-migration-token",
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
      return jsonResponse({ error: "Missing key" }, 400);
    }
    if (!request.body) {
      return jsonResponse({ error: "Missing body" }, 400);
    }
    const contentType =
      request.headers.get("content-type") || "application/octet-stream";
    await env.BOOKS_BUCKET.put(key, request.body, {
      httpMetadata: { contentType },
    });
    return jsonResponse({ ok: true, key });
  }

  return null;
};
