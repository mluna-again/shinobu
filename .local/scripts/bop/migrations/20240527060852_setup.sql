-- +goose Up
-- +goose StatementBegin
CREATE TABLE IF NOT EXISTS tokens (
  value TEXT NOT NULL,
  expiration TIMESTAMPTZ NOT NULL,
  refresh TEXT NOT NULL
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP DATABASE bop;
-- +goose StatementEnd
