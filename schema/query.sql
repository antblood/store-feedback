
-- name: GetAllFeedbacks :many
select * from feedback;

-- name: InsertFeedback :one
insert into feedback
(message) values ($1) returning *;

-- name: DeleteAllFeedbacks :exec
delete from feedback;