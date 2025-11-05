CREATE TABLE teenpay.users (
  id            BIGSERIAL PRIMARY KEY,
  first_name	TEXT,
  last_name 	TEXT,
  email         TEXT UNIQUE,
  phone         TEXT UNIQUE,
  password_hash TEXT,
  locale        TEXT DEFAULT 'en',
  created_at    timestamptz DEFAULT now(),
  updated_at    timestamptz DEFAULT now()
);

