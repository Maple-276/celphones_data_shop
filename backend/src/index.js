// API mínima de compras sobre D1 (SQLite). Rutas:
//   GET    /purchases?q=texto   -> lista/busca
//   POST   /purchases           -> crea
//   DELETE /purchases/:id        -> borra
// Auth: header  Authorization: Bearer <Firebase ID token>.
// ponytail: enrutado a mano; sin framework para 3 rutas. Mete Hono si crecen mucho.

import { jwtVerify, createRemoteJWKSet } from "jose";

// Llaves públicas de Firebase (formato JWKS). jose las cachea en memoria.
const FIREBASE_JWKS = createRemoteJWKSet(
  new URL("https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com")
);

// Verifica el ID token de Firebase. Devuelve el payload (con .user_id/.email) o null.
// ponytail: no hand-roll de RS256; jose valida firma, exp, iss y aud.
async function verifyFirebaseToken(token, projectId) {
  try {
    const { payload } = await jwtVerify(token, FIREBASE_JWKS, {
      issuer: `https://securetoken.google.com/${projectId}`,
      audience: projectId,
    });
    return payload.sub ? payload : null; // sub = uid; Firebase lo exige no-vacío
  } catch {
    return null;
  }
}

const json = (data, status = 200) =>
  new Response(JSON.stringify(data), {
    status,
    headers: { "content-type": "application/json" },
  });

// Mapea una fila de la DB al shape que espera el Flutter (camelCase).
const toApi = (r) => ({
  id: r.id,
  sellerName: r.seller_name,
  sellerPhone: r.seller_phone,
  sellerIdNumber: r.seller_id_number,
  sellerIdPhotoPath: r.seller_id_photo_path,
  purchaseMomentPhotoPath: r.purchase_moment_photo_path,
  deviceModel: r.device_model,
  deviceCapacity: r.device_capacity,
  imei: r.imei,
  serialNumber: r.serial_number,
  deviceDetails: r.device_details,
  deviceImagesPaths: JSON.parse(r.device_images_paths || "[]"),
  pricePaid: r.price_paid,
  customerSignature: r.customer_signature,
  createdAt: r.created_at,
});

export default {
  async fetch(request, env) {
    // Trust boundary: exige un ID token válido de Firebase en TODA petición. No lo quites.
    const auth = request.headers.get("authorization") || "";
    const token = auth.startsWith("Bearer ") ? auth.slice(7) : "";
    const user = await verifyFirebaseToken(token, env.FIREBASE_PROJECT_ID);
    if (!user) return json({ error: "no autorizado" }, 401);
    // user.sub = uid, user.email = correo del que inició sesión.

    const url = new URL(request.url);
    const parts = url.pathname.split("/").filter(Boolean); // ["purchases", ":id"?]
    const method = request.method;

    if (parts[0] !== "purchases") return json({ error: "ruta desconocida" }, 404);

    // GET /purchases?q=
    if (method === "GET" && !parts[1]) {
      const q = (url.searchParams.get("q") || "").trim();
      let rows;
      if (q) {
        const like = `%${q}%`;
        rows = await env.DB.prepare(
          `SELECT * FROM purchases
           WHERE owner_uid = ?2
             AND (device_model LIKE ?1 OR imei LIKE ?1 OR serial_number LIKE ?1
                  OR seller_name LIKE ?1 OR seller_id_number LIKE ?1)
           ORDER BY id DESC`
        ).bind(like, user.sub).all();
      } else {
        rows = await env.DB.prepare(
          `SELECT * FROM purchases WHERE owner_uid = ? ORDER BY id DESC`
        ).bind(user.sub).all();
      }
      return json((rows.results || []).map(toApi));
    }

    // POST /purchases
    if (method === "POST" && !parts[1]) {
      let b;
      try {
        b = await request.json();
      } catch {
        return json({ error: "JSON inválido" }, 400);
      }
      const res = await env.DB.prepare(
        `INSERT INTO purchases
          (owner_uid, seller_name, seller_phone, seller_id_number, seller_id_photo_path,
           purchase_moment_photo_path, device_model, device_capacity, imei,
           serial_number, device_details, device_images_paths, price_paid,
           customer_signature, created_at)
         VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?, COALESCE(?, datetime('now')))`
      ).bind(
        user.sub, // dueño = usuario logueado; el cliente NO decide esto
        b.sellerName ?? null,
        b.sellerPhone ?? null,
        b.sellerIdNumber ?? null,
        b.sellerIdPhotoPath ?? null,
        b.purchaseMomentPhotoPath ?? null,
        b.deviceModel ?? null,
        b.deviceCapacity ?? null,
        b.imei ?? null,
        b.serialNumber ?? null,
        b.deviceDetails ?? null,
        JSON.stringify(b.deviceImagesPaths ?? []),
        b.pricePaid ?? null,
        b.customerSignature ?? null,
        b.createdAt ?? null
      ).run();
      return json({ id: res.meta.last_row_id }, 201);
    }

    // DELETE /purchases/:id  (solo si la fila es del usuario)
    if (method === "DELETE" && parts[1]) {
      const res = await env.DB.prepare(
        `DELETE FROM purchases WHERE id = ? AND owner_uid = ?`
      ).bind(parts[1], user.sub).run();
      if (!res.meta.changes) return json({ error: "no encontrada" }, 404);
      return json({ ok: true });
    }

    return json({ error: "método no soportado" }, 405);
  },
};
