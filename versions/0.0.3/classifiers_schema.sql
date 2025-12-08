-- schema if not exist
CREATE SCHEMA IF NOT EXISTS classifiers;

-- table roles: ID, Code, Name
CREATE TABLE IF NOT EXISTS classifiers.roles (
    id   BIGSERIAL PRIMARY KEY,
    code TEXT NOT NULL UNIQUE,   -- ADMIN/PARENT/CHILD
    name TEXT NOT NULL           -- name
);

INSERT INTO classifiers.roles (code, name) VALUES
  ('ADMIN','Administrator'),
  ('PARENT','Parent'),
  ('CHILD','Child')
ON CONFLICT (code) DO UPDATE SET name = EXCLUDED.name;

-- если не создалась — создаём правильно
CREATE TABLE IF NOT EXISTS teenpay.authorities (
    user_id BIGINT NOT NULL
        REFERENCES teenpay.users(id) ON DELETE CASCADE,
    role_id BIGINT NOT NULL
        REFERENCES classifiers.roles(id) ON DELETE RESTRICT,
    granted_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, role_id)
);

INSERT INTO teenpay.authorities (user_id, role_id)
SELECT u.id, r.id
FROM teenpay.users u
JOIN classifiers.roles r ON UPPER(u.role) = r.code
ON CONFLICT DO NOTHING;

SELECT a.user_id, r.code, r.name, a.granted_at
FROM teenpay.authorities a
JOIN classifiers.roles r ON r.id = a.role_id
ORDER BY a.granted_at DESC;

