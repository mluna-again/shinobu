package main

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"

	"github.com/zmb3/spotify/v2"
)

var (
	noSearchQueryError = errors.New("No query provided")
)

type item struct {
	ID          string `json:"id"`
	DisplayName string `json:"display_name"`
	Artist      string `json:"artist"`
}

type searchParams struct {
	Query string `json:"query"`
}

func (app *app) search(w http.ResponseWriter, r *http.Request) {
	if app.client == nil {
		w.WriteHeader(http.StatusInternalServerError)
		_, err := w.Write([]byte("server says no (it's not ready)"))
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
		}
		return
	}

	defer r.Body.Close()
	var params searchParams
	d := json.NewDecoder(r.Body)
	err := d.Decode(&params)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		_, err := w.Write([]byte("error parsing request"))
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
		}
		return
	}

	query := params.Query
	if query == "" {
		w.WriteHeader(http.StatusBadRequest)
		_, err := w.Write([]byte(noSearchQueryError.Error()))
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
		}
		return
	}

	results, err := app.client.Search(context.Background(), query, spotify.SearchTypeTrack|spotify.SearchTypeAlbum)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		_, err := w.Write([]byte(err.Error()))
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
		}
		return
	}

	err = printResults(w, results)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
}

func printResults(w io.Writer, results *spotify.SearchResult) error {
	response := []item{}
	if results.Tracks != nil {
		for i, song := range results.Tracks.Tracks {
			if i >= 5 {
				break
			}
			item := item{
				ID:          string(song.ID),
				DisplayName: fmt.Sprintf("[SONG] %s", song.Name),
				Artist:      song.Artists[0].Name,
			}
			response = append(response, item)
		}
	}

	if results.Albums != nil {
		for i, album := range results.Albums.Albums {
			if i >= 5 {
				break
			}
			item := item{
				ID:          string(album.ID),
				DisplayName: fmt.Sprintf("[ALBUM] %s", album.Name),
				Artist:      album.Artists[0].Name,
			}
			response = append(response, item)
		}
	}

	if results.Playlists != nil {
		for i, playlist := range results.Playlists.Playlists {
			if i >= 5 {
				break
			}
			item := item{
				ID:          string(playlist.ID),
				DisplayName: fmt.Sprintf("[PLAYLIST] %s", playlist.Name),
			}
			response = append(response, item)
		}
	}

	output, err := json.Marshal(response)
	if err != nil {
		return err
	}

	_, err = w.Write(output)
	return err
}
