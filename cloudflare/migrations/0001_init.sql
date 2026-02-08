CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  phone TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  password_salt TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  last_login INTEGER,
  is_active INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS donors (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  location TEXT NOT NULL,
  blood_type TEXT NOT NULL,
  created_by TEXT,
  created_at INTEGER NOT NULL,
  is_active INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS doctors (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  specialization TEXT NOT NULL,
  presence TEXT NOT NULL,
  title TEXT NOT NULL,
  created_by TEXT,
  created_at INTEGER NOT NULL,
  is_active INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS professions (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  name_profession TEXT NOT NULL,
  created_by TEXT,
  created_at INTEGER NOT NULL,
  is_active INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS cars (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  vehicle_type TEXT NOT NULL,
  time TEXT NOT NULL,
  route_from TEXT NOT NULL,
  created_by TEXT,
  created_at INTEGER NOT NULL,
  is_active INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS satota (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  location TEXT NOT NULL,
  created_by TEXT,
  created_at INTEGER NOT NULL,
  is_active INTEGER NOT NULL DEFAULT 1
);

CREATE INDEX IF NOT EXISTS idx_donors_blood_type ON donors (blood_type);
CREATE INDEX IF NOT EXISTS idx_donors_phone ON donors (phone);
CREATE INDEX IF NOT EXISTS idx_doctors_phone ON doctors (phone);
CREATE INDEX IF NOT EXISTS idx_professions_phone ON professions (phone);
CREATE INDEX IF NOT EXISTS idx_cars_phone ON cars (phone);
CREATE INDEX IF NOT EXISTS idx_satota_phone ON satota (phone);
