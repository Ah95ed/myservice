CREATE TABLE IF NOT EXISTS account_deletion_tokens (
  token_hash TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  expires_at INTEGER NOT NULL,
  used_at INTEGER
);

CREATE INDEX IF NOT EXISTS idx_account_deletion_user ON account_deletion_tokens (user_id);
CREATE INDEX IF NOT EXISTS idx_account_deletion_expires ON account_deletion_tokens (expires_at);
