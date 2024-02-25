package main

import (
	"context"
	"errors"
	"os"
	"time"

	"github.com/jackc/pgx/v5"
	"golang.org/x/oauth2"
	spotifyauth "github.com/zmb3/spotify/v2/auth"
)

var dbNotInitializedErr = errors.New("Database connection is nil")

func newDb() (*pgx.Conn, error) {
	conn, err := pgx.Connect(context.Background(), os.Getenv("DATABASE_URL"))
	if err != nil {
		return nil, err
	}

	return conn, nil
}

func (a *app) retrieveToken(auth *spotifyauth.Authenticator) (*oauth2.Token, error) {
	if a.db == nil {
		return nil, dbNotInitializedErr
	}

	ctx, cancel := context.WithTimeout(context.Background(), time.Second*3)
	defer cancel()
	row := a.db.QueryRow(ctx, "SELECT value, expiration, refresh FROM tokens ORDER BY expiration DESC LIMIT 1")

	t := oauth2.Token{}
	err := row.Scan(&t.AccessToken, &t.Expiry, &t.RefreshToken)
	if err != nil {
		return nil, err
	}

	return &t, nil
}

func (a *app) saveToken(t *oauth2.Token) error {
	if a.db == nil {
		return dbNotInitializedErr
	}

	ctx, cancel := context.WithTimeout(context.Background(), time.Second*3)
	defer cancel()
	_, err := a.db.Exec(ctx,
		"INSERT INTO tokens (value, expiration, refresh) VALUES ($1, $2, $3)",
		t.AccessToken,
		t.Expiry.UTC().Format(time.RFC3339),
		t.RefreshToken)

	if err != nil {
		return err
	}

	return nil
}
