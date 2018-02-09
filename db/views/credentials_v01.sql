SELECT
    users.id AS user_id,
    users.email AS email,
    access_tokens.password_digest AS password_digest
FROM access_tokens
INNER JOIN users ON access_tokens.user_id = users.id

UNION

SELECT
    users.id AS user_id,
    users.email AS email,
    users.password_digest AS password_digest
FROM users
