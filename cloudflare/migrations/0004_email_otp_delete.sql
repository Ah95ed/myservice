CREATE TABLE IF NOT EXISTS account_delete_email_otp (
  user_id TEXT PRIMARY KEY,
  code_hash TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  expires_at INTEGER NOT NULL,
  attempts INTEGER NOT NULL DEFAULT 0,
  resend_count INTEGER NOT NULL DEFAULT 0,
  verified_at INTEGER
);

CREATE INDEX IF NOT EXISTS idx_account_delete_email_otp_expires ON account_delete_email_otp (expires_at);
