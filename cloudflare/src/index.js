import { handleAccountRoutes } from "./account.js";
import { handleAuthRoutes } from "./auth.js";
import { handleItemsRoutes } from "./items.js";
import { handleMiscRoutes } from "./misc.js";
import { handleR2Routes } from "./r2.js";
import { jsonResponse } from "./utils.js";

export default {
  async fetch(request, env) {
    if (request.method === "OPTIONS") {
      return jsonResponse({ ok: true }, 200);
    }

    const url = new URL(request.url);
    const path = url.pathname;

    let response = await handleMiscRoutes(request, env, path, url);
    if (response !== null) return response;

    response = await handleR2Routes(request, env, path, url);
    if (response !== null) return response;

    response = await handleAccountRoutes(request, env, path, url);
    if (response !== null) return response;

    response = await handleAuthRoutes(request, env, path);
    if (response !== null) return response;

    response = await handleItemsRoutes(request, env, path, url);
    if (response !== null) return response;

    return jsonResponse({ error: "Not found" }, 404);
  },
};
