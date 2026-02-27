import {
    badRequest,
    getAuthUser,
    getEditableColumns,
    isMigrationRequest,
    jsonResponse,
    mapUpdatePayload,
    parseJsonBody,
    parsePagination,
    tableByType,
    unauthorized,
} from "./utils.js";

export const handleItemsRoutes = async (request, env, path, url) => {
  if (path === "/donors" && request.method === "GET") {
    const user = await getAuthUser(request, env);
    const bloodType = url.searchParams.get("bloodType");
    const number = url.searchParams.get("number");
    const { limit, offset } = parsePagination(url);
    let query =
      "SELECT id, name, phone AS number, location, blood_type AS type, CASE WHEN created_by = ? THEN 1 ELSE 0 END AS canManage FROM donors WHERE is_active = 1";
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
    const result = await env.DB.prepare(query)
      .bind(...params)
      .all();
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

  if (
    ["/donors", "/doctors", "/professions", "/cars", "/satota"].includes(
      path,
    ) &&
    request.method === "POST"
  ) {
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
      if (!name || !phone || !location || !bloodType)
        return badRequest("Missing required fields");
      await env.DB.prepare(
        "INSERT INTO donors (id, name, phone, location, blood_type, created_by, created_at, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, 1)",
      )
        .bind(
          id,
          name,
          phone,
          location,
          bloodType,
          user?.sub ?? "migration",
          now,
        )
        .run();
      return jsonResponse({ id }, 201);
    }

    if (path === "/doctors") {
      const { name, phone, specialization, presence, title } = body;
      if (!name || !phone || !specialization || !presence || !title)
        return badRequest("Missing required fields");
      await env.DB.prepare(
        "INSERT INTO doctors (id, name, phone, specialization, presence, title, created_by, created_at, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)",
      )
        .bind(
          id,
          name,
          phone,
          specialization,
          presence,
          title,
          user?.sub ?? "migration",
          now,
        )
        .run();
      return jsonResponse({ id }, 201);
    }

    if (path === "/professions") {
      const { name, phone, nameProfession } = body;
      if (!name || !phone || !nameProfession)
        return badRequest("Missing required fields");
      await env.DB.prepare(
        "INSERT INTO professions (id, name, phone, name_profession, created_by, created_at, is_active) VALUES (?, ?, ?, ?, ?, ?, 1)",
      )
        .bind(id, name, phone, nameProfession, user?.sub ?? "migration", now)
        .run();
      return jsonResponse({ id }, 201);
    }

    if (path === "/cars") {
      const { name, phone, vehicleType, time, routeFrom } = body;
      if (!name || !phone || !vehicleType || !time || !routeFrom)
        return badRequest("Missing required fields");
      await env.DB.prepare(
        "INSERT INTO cars (id, name, phone, vehicle_type, time, route_from, created_by, created_at, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)",
      )
        .bind(
          id,
          name,
          phone,
          vehicleType,
          time,
          routeFrom,
          user?.sub ?? "migration",
          now,
        )
        .run();
      return jsonResponse({ id }, 201);
    }

    if (path === "/satota") {
      const { name, phone, location } = body;
      if (!name || !phone || !location)
        return badRequest("Missing required fields");
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

    let canDelete = false;
    if (
      user.is_admin === true ||
      user.email === "amhmeed31@gmail.com" ||
      user.phone === "07824854525" ||
      user.phone === "07824854526"
    ) {
      canDelete = true;
    } else {
      const owned = await env.DB.prepare(
        `SELECT id FROM ${table} WHERE id = ? AND created_by = ? LIMIT 1`,
      )
        .bind(id, user.sub)
        .first();
      if (owned) canDelete = true;
    }
    if (!canDelete) {
      return jsonResponse({ error: "Forbidden: owner only" }, 403);
    }
    await env.DB.prepare(`DELETE FROM ${table} WHERE id = ?`).bind(id).run();
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

    let canEdit = false;
    if (
      user.is_admin === true ||
      user.email === "amhmeed31@gmail.com" ||
      user.phone === "07824854525" ||
      user.phone === "07824854526"
    ) {
      canEdit = true;
    } else {
      const owned = await env.DB.prepare(
        `SELECT id FROM ${table} WHERE id = ? AND created_by = ? LIMIT 1`,
      )
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

  return null;
};
