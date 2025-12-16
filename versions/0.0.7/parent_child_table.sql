CREATE TABLE IF NOT EXISTS teenpay.parent_children (
  id bigserial PRIMARY KEY,
  parent_user_id int NOT NULL REFERENCES teenpay.users(id) ON DELETE CASCADE,
  child_user_id  int NOT NULL REFERENCES teenpay.users(id) ON DELETE CASCADE,
  UNIQUE (parent_user_id, child_user_id)
);

INSERT INTO teenpay.parent_children(parent_user_id, child_user_id)
VALUES (3, 7), (6, 4), (6, 8)
ON CONFLICT DO NOTHING;