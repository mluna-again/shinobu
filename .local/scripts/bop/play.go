package main

import (
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"time"

	"github.com/zmb3/spotify/v2"
)

var (
	noSongIdError = errors.New("No song ID provided")
)

type playParams struct {
	Item string `json:"item"`
	Type string `json:"type"`
}

func (app *app) playSong(w http.ResponseWriter, r *http.Request) {
	if app.client == nil {
		w.WriteHeader(http.StatusInternalServerError)
		_, err := w.Write([]byte("server says no (it's not ready)"))
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
		}
		return
	}

	defer r.Body.Close()
	d := json.NewDecoder(r.Body)
	var params playParams
	err := d.Decode(&params)
	if err != nil {
		app.sendInternalServerError(w, err)
		return
	}

	query := params.Item
	if query == "" {
		app.sendBadRequestWithMessage(w, "missing query")
		return
	}
	id := spotify.ID(query)

	var somethingDone bool
	var errorWhileAddingItem error
	if params.Type == "track" {
		errorWhileAddingItem = app.addSongToQueue(r.Context(), id)
		somethingDone = true
	}

	if params.Type == "album" {
		errorWhileAddingItem = app.addAlbumToQueue(r.Context(), id)
		somethingDone = true
	}

	if params.Type == "playlist" {
		errorWhileAddingItem = app.addPlaylistToQueue(r.Context(), id)
		somethingDone = true
	}

	if errorWhileAddingItem != nil {
		app.sendInternalServerErrorWithMessage(w, errorWhileAddingItem.Error())
		return
	}

	if !somethingDone {
		app.sendOk(w)
		return
	}
	err = app.client.Next(r.Context())
	if err != nil {
		app.sendInternalServerError(w, err)
		return
	}

	_ = app.sendContent(w, []byte("ok"))
}

func (app *app) addAlbumToQueue(c context.Context, album spotify.ID) error {
	info, err := app.client.GetAlbum(c, album)
	if err != nil {
		return err
	}

	if len(info.Tracks.Tracks) < 1 {
		return nil
	}
	first := info.Tracks.Tracks[0]

	err = app.addSongToQueue(c, first.ID)
	if err != nil {
		return err
	}

	if len(info.Tracks.Tracks) < 2 {
		return nil
	}
	remainingSongs := info.Tracks.Tracks[1:len(info.Tracks.Tracks)]

	go func(tracks []spotify.SimpleTrack) {
		// why would they not allow to queue a whole album in a single request -_-
		for _, song := range tracks {
			ctx, cancel := context.WithTimeout(context.Background(), time.Second*3)
			defer cancel()
			err := app.addSongToQueue(ctx, song.ID)
			if err != nil {
				app.errLogger.Error(err)
				return
			}

			time.Sleep(time.Millisecond * 1500)
		}
	}(remainingSongs)

	return nil
}

func (app *app) addPlaylistToQueue(c context.Context, list spotify.ID) error {
	info, err := app.client.GetAlbum(c, list)
	if err != nil {
		return err
	}

	for _, song := range info.Tracks.Tracks {
		err := app.addSongToQueue(c, song.ID)
		if err != nil {
			return err
		}
	}

	return nil
}

func (app *app) addSongToQueue(c context.Context, track spotify.ID) error {
	return app.client.QueueSong(c, track)
}
