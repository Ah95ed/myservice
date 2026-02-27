CREATE TABLE IF NOT EXISTS signup_otps (
    email TEXT,
    phone TEXT,
    code TEXT NOT NULL,
    expires_at INTEGER NOT NULL,
    created_at INTEGER NOT NULL,
    PRIMARY KEY (email, phone)
);
