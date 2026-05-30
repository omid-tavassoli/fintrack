CREATE TABLE transactions (
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category_id     BIGINT REFERENCES categories(id) ON DELETE SET NULL,
    amount          DECIMAL(12,2) NOT NULL,
    description     VARCHAR(500),
    counterpart     VARCHAR(255),
    transaction_date DATE NOT NULL,
    hash            VARCHAR(64) NOT NULL UNIQUE,
    is_anomaly      BOOLEAN NOT NULL DEFAULT FALSE,
    gemini_used     BOOLEAN NOT NULL DEFAULT FALSE,
    created_at      TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_date ON transactions(transaction_date);
CREATE INDEX idx_transactions_category ON transactions(category_id);