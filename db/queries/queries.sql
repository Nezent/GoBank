-- name: CreateUser :one
INSERT INTO users (
  username, 
  currency,
  balance
) VALUES (
  $1, $2, $3
) RETURNING *;

-- name: GetUser :one
SELECT * FROM users
WHERE id = $1 LIMIT 1;

-- name: ListUser :many
SELECT * FROM users
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateUser :one
UPDATE users
SET balance = $2
WHERE id = $1
RETURNING *;

-- name: DeleteUser :exec
DELETE FROM users
WHERE id = $1;

-- name: CreateTransfer :one
INSERT INTO transfers (
  from_user_id, 
  to_user_id,
  amount
) VALUES (
  $1, $2, $3
) RETURNING *;


-- name: CreateEntry :one
INSERT INTO entries (
  user_id, 
  amount
) VALUES (
  $1, $2
) RETURNING *;