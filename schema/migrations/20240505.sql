--migrate:up
CREATE INDEX message_index ON feedback (message);


--migrate:down
DROP INDEX IF EXISTS message_index;
