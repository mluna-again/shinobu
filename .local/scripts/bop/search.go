package main

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"unicode/utf8"

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
		sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	query := params.Query
	if query == "" {
		sendBadRequestWithMessage(w, noSearchQueryError.Error())
		return
	}

	var queryPrefix string
	queryBody := query
	if utf8.RuneCount([]byte(query)) > 2 {
		queryPrefix = string([]rune(query)[0:2])
		queryBody = string([]rune(query)[2:])
	}

	var results *spotify.SearchResult
	switch queryPrefix {
	case "a:":
		results, err = app.searchAlbum(r.Context(), queryBody)
	case "s:":
		results, err = app.searchTrack(r.Context(), queryBody)
	case "l:":
		results, err = app.searchPlaylist(r.Context(), queryBody)
	default:
		results, err = app.client.Search(r.Context(), query, spotify.SearchTypeTrack|spotify.SearchTypeAlbum|spotify.SearchTypePlaylist)
	}

	if err != nil {
		sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	err = printResults(w, results)
	if err != nil {
		sendInternalServerErrorWithMessage(w, err.Error())
		return
	}
}

func (app *app) searchAlbum(c context.Context, query string) (*spotify.SearchResult, error) {
	return app.client.Search(c, query, spotify.SearchTypeAlbum)
}

func (app *app) searchTrack(c context.Context, query string) (*spotify.SearchResult, error) {
	return app.client.Search(c, query, spotify.SearchTypeTrack)
}

func (app *app) searchPlaylist(c context.Context, query string) (*spotify.SearchResult, error) {
	return app.client.Search(c, query, spotify.SearchTypePlaylist)
}

func printResults(w io.Writer, results *spotify.SearchResult) error {
	response := []item{}
	if results.Tracks != nil {
		for _, song := range results.Tracks.Tracks {
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
