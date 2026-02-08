CREATE TABLE IF NOT EXISTS edit_requests (
  id TEXT PRIMARY KEY,
  phone TEXT NOT NULL,
  payload TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  created_by TEXT
);

CREATE INDEX IF NOT EXISTS idx_edit_requests_phone ON edit_requests (phone);
