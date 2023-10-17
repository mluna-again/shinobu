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
	if results.Tracks != nil {
		for i, song := range results.Tracks.Tracks {
			if i >= 5 {
				break
			}
			_, err := fmt.Fprintf(w, "%s %s by %s\n", song.URI, song.Name, song.Artists[0].Name)
			if err != nil {
				return err
			}
		}
	}

	if results.Albums != nil {
		for i, album := range results.Albums.Albums {
			if i >= 5 {
				break
			}
			_, err := fmt.Fprintf(w, "%s %s by %s\n", album.URI, album.Name, album.Artists[0].Name)
			if err != nil {
				return err
			}
		}
	}

	if results.Playlists != nil {
		for i, playlist := range results.Playlists.Playlists {
			if i >= 5 {
				break
			}
			_, err := fmt.Fprintf(w, "%s %s by %s\n", playlist.URI, playlist.Name, playlist.Owner.DisplayName)
			if err != nil {
				return err
			}
		}
	}

	return nil
}
