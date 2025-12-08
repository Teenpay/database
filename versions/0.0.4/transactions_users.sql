ALTER TABLE teenpay.transactions
  ADD COLUMN IF NOT EXISTS school_id BIGINT;

ALTER TABLE teenpay.transactions
  ADD CONSTRAINT transactions_school_fk
  FOREIGN KEY (school_id)
  REFERENCES teenpay.schools(id)
  ON DELETE RESTRICT;

ALTER TABLE teenpay.transactions
  ADD COLUMN IF NOT EXISTS child_id BIGINT;

  ALTER TABLE teenpay.transactions
  ADD CONSTRAINT transactions_child_fk
  FOREIGN KEY (child_id)
  REFERENCES teenpay.users(id)
  ON DELETE RESTRICT;

SELECT
    t.id,
    t.user_id,
    t.amount,
    t.kind,
    t.description,
    t.created_at
FROM teenpay.transactions t
WHERE t.user_id = 4          -- здесь конкретный ID
ORDER BY t.created_at DESC;


  