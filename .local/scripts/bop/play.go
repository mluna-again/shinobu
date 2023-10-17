package main

import (
	"encoding/json"
	"errors"
	"net/http"

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

	err = app.client.QueueSong(r.Context(), id)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		_, err := w.Write([]byte(err.Error()))
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
		}
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
