-- Table: teenpay.transactions

-- DROP TABLE IF EXISTS teenpay.transactions;

CREATE TABLE IF NOT EXISTS teenpay.transactions
(
    id bigint NOT NULL DEFAULT nextval('teenpay.transactions_id_seq'::regclass),
    user_id bigint NOT NULL,
    amount numeric(12,2) NOT NULL,
    kind text COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    school_id bigint,
    child_id bigint,
    CONSTRAINT transactions_pkey PRIMARY KEY (id),
    CONSTRAINT transactions_child_fk FOREIGN KEY (child_id)
        REFERENCES teenpay.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT transactions_school_fk FOREIGN KEY (school_id)
        REFERENCES teenpay.schools (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT transactions_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES teenpay.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT transactions_kind_check CHECK (kind = ANY (ARRAY['TOPUP'::text, 'PAYMENT'::text, 'REFUND'::text, 'ADJUST'::text]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS teenpay.transactions
    OWNER to postgres;
-- Index: ix_transactions_user_created

-- DROP INDEX IF EXISTS teenpay.ix_transactions_user_created;

CREATE INDEX IF NOT EXISTS ix_transactions_user_created
    ON teenpay.transactions USING btree
    (user_id ASC NULLS LAST, created_at DESC NULLS FIRST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;
	
INSERT INTO teenpay.transactions (user_id, amount, kind, description, created_at, school_id, child_id)
VALUES
-- Janis (child=7):
(7,  20.00, 'TOPUP','Top-up by parent Artem',now() - interval '6 days', NULL, 7),
(7,  -3.50, 'PAYMENT','POS Zane: cafeteria sandwich',now() - interval '5 days 4 hours', NULL, 7),
(7,  -1.20, 'PAYMENT','POS Zane: juice',now() - interval '5 days 4 hours' + interval '3 minutes', NULL, 7),
(7,  -2.00, 'PAYMENT','POS Zane: snack',now() - interval '3 days 2 hours', NULL, 7),
(7,   1.20, 'REFUND','Refund from POS Zane: cancelled item',now() - interval '3 days 1 hour 50 minutes', NULL, 7);

INSERT INTO teenpay.transactions (user_id, amount, kind, description, created_at, school_id, child_id)
VALUES
-- Milena (child=8): 
(8,  15.00, 'TOPUP','Top-up by parent Liana',now() - interval '4 days 6 hours', NULL, 8),
(8,  -4.80, 'PAYMENT','POS Zane: lunch set',now() - interval '4 days 5 hours 40 minutes', NULL, 8),
(8,  -0.90, 'PAYMENT','POS Zane: water',now() - interval '2 days 7 hours', NULL, 8),
(8,   3.00, 'ADJUST','Balance adjustment (test bonus)', now() - interval '1 day 3 hours', NULL, 8);

INSERT INTO teenpay.transactions (user_id, amount, kind, description, created_at, school_id, child_id)
VALUES
-- Zane (POS/admin=9): 
(9,  50.00, 'TOPUP','POS float / cash-in (test)', now() - interval '7 days', NULL, NULL),
(9,  -1.00, 'ADJUST','POS adjustment: rounding / cashbox check',now() - interval '2 days 2 hours', NULL, NULL),
(9,  -0.50, 'ADJUST','POS fee (test)', now() - interval '12 hours', NULL, NULL);

INSERT INTO teenpay.transactions (user_id, amount, kind, description, created_at, school_id, child_id)
VALUES
(7,  10.00, 'TOPUP', 'Top-up (weekly allowance)',now() - interval '10 days 2 hours', NULL, 7),
(7,  -2.70, 'PAYMENT', 'POS Zane: bun + tea',now() - interval '10 days 1 hour 30 minutes', NULL, 7),
(7,  -1.10, 'PAYMENT', 'POS Zane: cookie',now() - interval '9 days 6 hours', NULL, 7),
(7,  -4.20, 'PAYMENT', 'POS Zane: lunch',now() - interval '9 days 5 hours 40 minutes', NULL, 7),
(7,   2.00, 'ADJUST',  'Bonus (good grades) - test',now() - interval '9 days 1 hour', NULL, 7),
(7,  -0.80, 'PAYMENT', 'POS Zane: water',now() - interval '8 days 7 hours', NULL, 7),
(7,  -1.50, 'PAYMENT', 'POS Zane: apple',now() - interval '8 days 7 hours' + interval '4 minutes', NULL, 7),
(7,  -2.30, 'PAYMENT', 'POS Zane: salad',now() - interval '7 days 3 hours', NULL, 7),
(7,   0.50, 'REFUND',  'Refund from POS Zane: item unavailable',now() - interval '7 days 2 hours 50 minutes', NULL, 7),
(7,  -3.90, 'PAYMENT', 'POS Zane: pasta',now() - interval '6 days 5 hours', NULL, 7),
(7,  -1.60, 'PAYMENT', 'POS Zane: yogurt',now() - interval '6 days 4 hours 58 minutes', NULL, 7),
(7,   5.00, 'TOPUP',   'Top-up (extra)',now() - interval '6 days 1 hour', NULL, 7),
(7,  -2.00, 'PAYMENT', 'POS Zane: snack',now() - interval '5 days 1 hour 10 minutes', NULL, 7),
(7,  -0.95, 'PAYMENT', 'POS Zane: juice',now() - interval '4 days 6 hours', NULL, 7),
(7,  -3.30, 'PAYMENT', 'POS Zane: lunch set',now() - interval '4 days 5 hours 45 minutes', NULL, 7);

INSERT INTO teenpay.transactions (user_id, amount, kind, description, created_at, school_id, child_id)
VALUES
(8,  12.00, 'TOPUP',   'Top-up (weekly allowance)',                      now() - interval '10 days 3 hours', NULL, 8),
(8,  -2.20, 'PAYMENT', 'POS Zane: soup',                                 now() - interval '10 days 2 hours 20 minutes', NULL, 8),
(8,  -1.00, 'PAYMENT', 'POS Zane: water',                                now() - interval '9 days 7 hours 10 minutes', NULL, 8),
(8,  -3.80, 'PAYMENT', 'POS Zane: lunch',                                now() - interval '9 days 6 hours 55 minutes', NULL, 8),
(8,   1.50, 'ADJUST',  'Bonus (sports) - test',                          now() - interval '9 days 1 hour 30 minutes', NULL, 8),
(8,  -0.70, 'PAYMENT', 'POS Zane: cookie',                               now() - interval '8 days 8 hours', NULL, 8),
(8,  -2.90, 'PAYMENT', 'POS Zane: sandwich',                             now() - interval '8 days 7 hours 40 minutes', NULL, 8),
(8,  -1.40, 'PAYMENT', 'POS Zane: yogurt',                               now() - interval '7 days 4 hours 10 minutes', NULL, 8),
(8,   0.70, 'REFUND',  'Refund from POS Zane: returned item',            now() - interval '7 days 4 hours 2 minutes', NULL, 8),
(8,  -4.10, 'PAYMENT', 'POS Zane: lunch set',                            now() - interval '6 days 6 hours 30 minutes', NULL, 8),
(8,  -1.30, 'PAYMENT', 'POS Zane: juice',                                now() - interval '6 days 6 hours 20 minutes', NULL, 8),
(8,   5.00, 'TOPUP',   'Top-up (extra)',                                 now() - interval '6 days 30 minutes', NULL, 8),
(8,  -2.10, 'PAYMENT', 'POS Zane: snack',                                now() - interval '5 days 2 hours', NULL, 8),
(8,  -3.50, 'PAYMENT', 'POS Zane: pasta',                                now() - interval '4 days 7 hours 25 minutes', NULL, 8);

INSERT INTO teenpay.transactions (user_id, amount, kind, description, created_at, school_id, child_id)
VALUES
(9, 100.00, 'TOPUP',   'POS float / cash-in (test)',                     now() - interval '11 days', NULL, NULL),
(9,  20.00, 'TOPUP',   'POS float / cash-in (test)',                     now() - interval '8 days', NULL, NULL),
(9,  -2.00, 'ADJUST',  'POS adjustment: cashbox difference (test)',       now() - interval '7 days 1 hour', NULL, NULL),
(9,  -1.20, 'ADJUST',  'POS fee (test)',                                 now() - interval '5 days 6 hours', NULL, NULL),
(9,   5.00, 'ADJUST',  'POS correction (test)',                          now() - interval '3 days 12 hours', NULL, NULL),
(9,  -0.80, 'ADJUST',  'POS rounding (test)',                            now() - interval '2 days 1 hour', NULL, NULL),
(9,  -1.50, 'ADJUST',  'POS service fee (test)',                         now() - interval '18 hours', NULL, NULL),
(9,   2.50, 'ADJUST',  'POS adjustment: manual correction (test)',       now() - interval '6 hours', NULL, NULL);