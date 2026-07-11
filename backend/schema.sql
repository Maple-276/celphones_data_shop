-- Tabla de compras. Refleja PurchaseModel (lib/models/purchase_model.dart).
-- Las imágenes se guardan como rutas/URLs (texto); la firma como base64.
-- ponytail: fotos como texto por ahora. Sube binarios reales a R2 cuando de verdad los necesites.
CREATE TABLE IF NOT EXISTS purchases (
  id                         INTEGER PRIMARY KEY AUTOINCREMENT,
  owner_uid                  TEXT NOT NULL,  -- uid de Firebase; aísla los datos por usuario
  seller_name                TEXT,
  seller_phone               TEXT,
  seller_id_number           TEXT,
  seller_id_photo_path       TEXT,
  purchase_moment_photo_path TEXT,
  device_model               TEXT,
  device_capacity            TEXT,
  imei                       TEXT,
  serial_number              TEXT,
  device_details             TEXT,
  device_images_paths        TEXT,   -- JSON array
  price_paid                 REAL,
  customer_signature         TEXT,   -- base64
  created_at                 TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Todo se consulta filtrando por dueño; índice clave.
CREATE INDEX IF NOT EXISTS idx_purchases_owner  ON purchases(owner_uid);
-- Búsquedas por los campos que usa search() en purchase_store.dart
CREATE INDEX IF NOT EXISTS idx_purchases_imei   ON purchases(imei);
CREATE INDEX IF NOT EXISTS idx_purchases_seller ON purchases(seller_id_number);
