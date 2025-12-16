CREATE TABLE IF NOT EXISTS teenpay.student_schools (
  id serial PRIMARY KEY,
  user_id int NOT NULL REFERENCES teenpay.users(id),
  school_id int NOT NULL REFERENCES teenpay.schools(id),
  UNIQUE(user_id, school_id)
);