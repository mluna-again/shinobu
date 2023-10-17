package main

import (
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"strings"

	"github.com/zmb3/spotify/v2"
)

var (
	noSongIdError = errors.New("No song ID provided")
)

type playParams struct {
	Item string `json:"item"`
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
		w.WriteHeader(http.StatusInternalServerError)
		_, err := w.Write([]byte("error parsing request"))
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
		}
		return
	}

	query := params.Item
	if query == "" {
		w.WriteHeader(http.StatusBadRequest)
		_, err := w.Write([]byte(noSongIdError.Error()))
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
		}
		return
	}
	id := spotify.ID(query)

	var somethingDone bool
	var errorWhileAddingItem error
	if strings.Contains(string(id), "track") {
		errorWhileAddingItem = app.addSongToQueue(r.Context(), id)
		somethingDone = true
	}

	if strings.Contains(string(id), "album") {
		errorWhileAddingItem = app.addAlbumToQueue(r.Context(), id)
		somethingDone = true
	}

	if strings.Contains(string(id), "playlist") {
		errorWhileAddingItem = app.addPlaylistToQueue(r.Context(), id)
		somethingDone = true
	}

	if errorWhileAddingItem != nil {
		sendInternalServerErrorWithMessage(w, errorWhileAddingItem.Error())
		return
	}

	if !somethingDone {
		return
	}
	err = app.client.Next(r.Context())
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		_, err := w.Write([]byte(err.Error()))
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
		}
		return
	}

	w.WriteHeader(http.StatusOK)
	_, err = w.Write([]byte("ok"))
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
	}
}

func (app *app) addAlbumToQueue(c context.Context, album spotify.ID) error {
	info, err := app.client.GetAlbum(c, album)
	if err != nil {
		return err
	}

	// why would they not allow to queue a whole album in a single request -_-
	for _, song := range info.Tracks.Tracks {
		err := app.addSongToQueue(c, song.ID)
		if err != nil {
			return err
		}
	}

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
