-- Table: teenpay.users

-- DROP TABLE IF EXISTS teenpay.users;

CREATE TABLE IF NOT EXISTS teenpay.users
(
    id bigint NOT NULL DEFAULT nextval('teenpay.users_id_seq'::regclass),
    email text COLLATE pg_catalog."default",
    phone text COLLATE pg_catalog."default",
    password_hash text COLLATE pg_catalog."default" NOT NULL,
    locale text COLLATE pg_catalog."default" DEFAULT 'en'::text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    username text COLLATE pg_catalog."default" NOT NULL,
    first_name text COLLATE pg_catalog."default",
    last_name text COLLATE pg_catalog."default",
    role text COLLATE pg_catalog."default",
    balance numeric(12,2) NOT NULL DEFAULT 0,
    CONSTRAINT users_pkey PRIMARY KEY (id),
    CONSTRAINT users_email_key UNIQUE (email),
    CONSTRAINT users_phone_key UNIQUE (phone),
    CONSTRAINT users_role_fk FOREIGN KEY (role)
        REFERENCES classifiers.roles (code) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS teenpay.users
    OWNER to postgres;
-- Index: ix_users_username

-- DROP INDEX IF EXISTS teenpay.ix_users_username;

CREATE UNIQUE INDEX IF NOT EXISTS ix_users_username
    ON teenpay.users USING btree
    (username COLLATE pg_catalog."default" ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: ix_users_username_lower

-- DROP INDEX IF EXISTS teenpay.ix_users_username_lower;

CREATE UNIQUE INDEX IF NOT EXISTS ix_users_username_lower
    ON teenpay.users USING btree
    (lower(username) COLLATE pg_catalog."default" ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;

	ALTER TABLE teenpay.users
ADD COLUMN IF NOT EXISTS public_code text UNIQUE,
ADD COLUMN IF NOT EXISTS school_code text;

-- Если хочешь быстро заполнить public_code тем, у кого NULL:
UPDATE teenpay.users
SET public_code = 'TP-' || id::text
WHERE public_code IS NULL;
