CREATE TABLE user_category_rules (
    id          BIGSERIAL PRIMARY KEY ,
    user_id     BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category_id BIGINT NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    keyword     VARCHAR(255) NOT NULL ,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW() ,
    UNIQUE (user_id, keyword)
);