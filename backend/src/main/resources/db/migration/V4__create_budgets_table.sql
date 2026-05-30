CREATE TABLE budgets (
     id          BIGSERIAL PRIMARY KEY,
     user_id     BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
     category_id BIGINT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
     amount      DECIMAL(12,2) NOT NULL,
     month       INT NOT NULL CHECK (month BETWEEN 1 AND 12),
     year        INT NOT NULL,
     created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
     UNIQUE(user_id, category_id, month, year)
);