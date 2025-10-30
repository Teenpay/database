CREATE SCHEMA IF NOT EXISTS teenpay;

CREATE TABLE IF NOT EXISTS teenpay.users
(
    id             SERIAL PRIMARY KEY,
    name           TEXT,
    surname        TEXT,
    age            INTEGER,
    child          TEXT,
    balance        NUMERIC(12,2),

    -- поля аутентификации
    username       TEXT,
    password_hash  TEXT
);

-- 2.1) Гарантируем, что нужные колонки присутствуют и не null
ALTER TABLE teenpay.users
    ADD COLUMN IF NOT EXISTS username      TEXT,
    ADD COLUMN IF NOT EXISTS password_hash TEXT;

-- username обязателен и уникален
-- (на случай, если в таблице уже есть строки с NULL — сначала временно заполни их)
UPDATE teenpay.users SET username = CONCAT('user_', id)
WHERE username IS NULL;

ALTER TABLE teenpay.users
    ALTER COLUMN username SET NOT NULL,
    ALTER COLUMN password_hash SET NOT NULL;

-- уникальный индекс по логину
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'ix_users_username'
          AND n.nspname = 'teenpay'
    ) THEN
        CREATE UNIQUE INDEX ix_users_username ON teenpay.users(username);
    END IF;
END $$;

-- 3) Таблица refresh_tokens
CREATE TABLE IF NOT EXISTS teenpay.refresh_tokens
(
    id              SERIAL PRIMARY KEY,
    token           TEXT NOT NULL,
    expires_at_utc  TIMESTAMPTZ NOT NULL,
    created_at_utc  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    device_id       TEXT,
    revoked         BOOLEAN NOT NULL DEFAULT FALSE,

    user_id         INTEGER NOT NULL REFERENCES teenpay.users(id) ON DELETE CASCADE
);

-- уникальный индекс по самому refresh-токену
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'ix_refresh_tokens_token'
          AND n.nspname = 'teenpay'
    ) THEN
        CREATE UNIQUE INDEX ix_refresh_tokens_token ON teenpay.refresh_tokens(token);
    END IF;
END $$;

-- 4) (опционально) ускорить логин по имени пользователя
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE c.relname = 'ix_users_username_lower'
          AND n.nspname = 'teenpay'
    ) THEN
        CREATE UNIQUE INDEX ix_users_username_lower
        ON teenpay.users (LOWER(username));
    END IF;
END $$;

-- 5) Проверка
-- SELECT * FROM teenpay.users LIMIT 10;
-- SELECT * FROM teenpay.refresh_tokens LIMIT 10;
