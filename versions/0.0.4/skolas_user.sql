CREATE TABLE IF NOT EXISTS teenpay.schools (
    id          BIGSERIAL PRIMARY KEY,
    code        TEXT NOT NULL UNIQUE,      -- iss kods: RIGA_25, LVG, RTG...
    name        TEXT NOT NULL,             -- pilnais nosaukums
    city        TEXT,                      -- pilseta 
    address     TEXT,                      -- adrese 
    created_at  timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE teenpay.schools
  ADD COLUMN IF NOT EXISTS account_number text,      -- konta numurs
  ADD COLUMN IF NOT EXISTS payment_code  text;  	-- kods

ALTER TABLE teenpay.schools
  ADD CONSTRAINT schools_payment_code_uk
  UNIQUE (payment_code);

  ALTER TABLE teenpay.schools
  ALTER COLUMN payment_code SET NOT NULL;

  INSERT INTO teenpay.schools
    (code,name,city,address,account_number,payment_code)
    VALUES
    ('RIGA_25','Rīgas 25. vidusskola','Rīga','Brīvības iela 123','LV00TPAY0000000001','SCH-RIGA25-A1B2'),
    ('RIGA_GYM','Rīgas Valsts ģimnāzija','Rīga','Skolas iela 5','LV00TPAY0000000002','SCH-RIGAGYM-C3D4'),
    ('LIEPAJA_1','Liepājas 1. vidusskola','Liepāja','Kuršu iela 10','LV00TPAY0000000003','SCH-LIEPAJA1-E5F6'),
    ('JURMALA_G','Jūrmalas Valsts ģimnāzija','Jūrmala','Jomas iela 77','LV00TPAY0000000004','SCH-JURMALAG-G7H8'),
    ('OGRE_GYM', 'Ogres Valsts ģimnāzija','Ogre','Skolas iela 2','LV00TPAY0000000005','SCH-OGREGYM-J9K0');

