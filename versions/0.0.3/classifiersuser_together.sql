UPDATE teenpay.users
SET role = UPPER(role);

SELECT DISTINCT u.role
FROM teenpay.users u
LEFT JOIN classifiers.roles r ON r.code = u.role
WHERE r.id IS NULL;

ALTER TABLE teenpay.users
  ADD CONSTRAINT users_role_fk
  FOREIGN KEY (role)
  REFERENCES classifiers.roles(code)
  ON UPDATE CASCADE
  ON DELETE RESTRICT;