package server

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
	ID            string `json:"id"`
	DisplayName   string `json:"display_name"`
	Artist        string `json:"artist"`
	ImageUrl      string `json:"image_url"`
	CurrentSecond int    `json:"current_second"`
	TotalSeconds  int    `json:"total_seconds"`
	IsPlaying     bool   `json:"is_playing"`
	Album         string `json:"album"`
}

type searchParams struct {
	Query string `json:"query"`
}

func (app *app) search(w http.ResponseWriter, r *http.Request) {
	if app.client == nil {
		app.sendServerNotReadyError(w)
		return
	}

	defer r.Body.Close()
	var params searchParams
	d := json.NewDecoder(r.Body)
	err := d.Decode(&params)
	if err != nil {
		app.sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	query := params.Query
	if query == "" {
		app.sendBadRequestWithMessage(w, noSearchQueryError.Error())
		return
	}

	var queryPrefix string
	queryBody := query
	if utf8.RuneCount([]byte(query)) > 2 {
		queryPrefix = string([]rune(query)[0:2])
		queryBody = string([]rune(query)[2:])
	}

	queryType := "all"
	var results *spotify.SearchResult
	switch queryPrefix {
	case "a:":
		results, err = app.searchAlbum(r.Context(), queryBody)
		queryType = "album"
	case "s:":
		results, err = app.searchTrack(r.Context(), queryBody)
		queryType = "track"
	case "l:":
		results, err = app.searchPlaylist(r.Context(), queryBody)
		queryType = "playlist"
	default:
		results, err = app.client.Search(r.Context(), query, spotify.SearchTypeTrack|spotify.SearchTypeAlbum|spotify.SearchTypePlaylist)
	}

	if err != nil {
		app.sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	w.Header().Add("content-type", "application/json")
	err = printResults(w, results, queryType)
	if err != nil {
		app.sendInternalServerErrorWithMessage(w, err.Error())
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

func printResults(w io.Writer, results *spotify.SearchResult, qType string) error {
	response := []item{}
	if results.Tracks != nil {
		for _, song := range results.Tracks.Tracks {
			item := item{
				ID:          string(song.ID),
				DisplayName: fmt.Sprintf("[SONG] %s", song.Name),
				Artist:      song.Artists[0].Name,
				ImageUrl:    song.Album.Images[0].URL,
			}
			response = append(response, item)
		}
	}

	if results.Albums != nil {
		for i, album := range results.Albums.Albums {
			if i >= 5 && qType != "album" {
				break
			}
			item := item{
				ID:          string(album.ID),
				DisplayName: fmt.Sprintf("[ALBUM] %s", album.Name),
				Artist:      album.Artists[0].Name,
				ImageUrl:    album.Images[0].URL,
			}
			response = append(response, item)
		}
	}

	if results.Playlists != nil {
		for i, playlist := range results.Playlists.Playlists {
			if i >= 5 && qType != "playlist" {
				break
			}
			item := item{
				ID:          string(playlist.ID),
				DisplayName: fmt.Sprintf("[PLAYLIST] %s", playlist.Name),
				Artist:      playlist.Owner.DisplayName,
				ImageUrl:    playlist.Images[0].URL,
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
