CREATE TABLE IF NOT EXISTS teenpay.transactions (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT NOT NULL
        REFERENCES teenpay.users(id) ON DELETE CASCADE,
    amount      NUMERIC(12,2) NOT NULL,
    kind        TEXT NOT NULL CHECK (kind IN ('TOPUP','PAYMENT','REFUND','ADJUST')),
    description TEXT,
    created_at  timestamptz NOT NULL DEFAULT now()
);

-- Индекс, чтобы быстро искать операции пользователя по дате
CREATE INDEX IF NOT EXISTS ix_transactions_user_created
    ON teenpay.transactions (user_id, created_at DESC);

	SELECT t.id, u.username, t.amount, t.kind, t.created_at
FROM teenpay.transactions t
JOIN teenpay.users u ON u.id = t.user_id
ORDER BY t.id;
