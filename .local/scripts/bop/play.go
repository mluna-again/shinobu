package main

import (
	"context"
	"errors"

	"github.com/zmb3/spotify/v2"
)

var (
	noSongIdError = errors.New("No song ID provided")
)

func (app *app) playSong() error {
	if app.query == "" {
		return noSongIdError
	}
	id := spotify.ID(app.query)

	err := app.client.QueueSong(context.Background(), id)
	if err != nil {
		return err
	}

	return app.client.Next(context.Background())
}
