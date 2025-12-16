CREATE TABLE teenpay.topup_requests (
    id            bigserial PRIMARY KEY,
    child_id      bigint NOT NULL REFERENCES teenpay.users(id),
    parent_id     bigint NOT NULL REFERENCES teenpay.users(id),
    status        text   NOT NULL DEFAULT 'PENDING', -- PENDING / APPROVED / REJECTED
    requested_at  timestamptz NOT NULL DEFAULT now(),
    approved_at   timestamptz NULL,
    note          text NULL
);

CREATE INDEX ix_topup_requests_parent_status ON teenpay.topup_requests(parent_id, status);
CREATE INDEX ix_topup_requests_child_status  ON teenpay.topup_requests(child_id, status);
