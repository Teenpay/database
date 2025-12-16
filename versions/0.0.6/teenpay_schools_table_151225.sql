SELECT * FROM teenpay.schools
ORDER BY id ASC 

ALTER TABLE teenpay.schools
ADD COLUMN pos_user_id integer;

-- (желательно) FK на users
ALTER TABLE teenpay.schools
ADD CONSTRAINT fk_schools_pos_user
FOREIGN KEY (pos_user_id)
REFERENCES teenpay.users(id)
ON DELETE RESTRICT;

CREATE INDEX IF NOT EXISTS ix_schools_pos_user_id
ON teenpay.schools(pos_user_id);

