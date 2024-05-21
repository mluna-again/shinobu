package server

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strings"
	"time"

	"github.com/zmb3/spotify/v2"
)

type advancedSearchParams struct {
	Query string `json:"query"`
	From  string `json:"from"`
	By    string `json:"by"`
}

func (a *app) advancedSearch(w http.ResponseWriter, r *http.Request) {
	var params advancedSearchParams
	d := json.NewDecoder(r.Body)
	err := d.Decode(&params)
	if err != nil {
		a.sendBadRequestWithMessage(w, "invalid params")
		return
	}
	defer r.Body.Close()

	if params.From != "" {
		a.searchAdvancedAlbum(w, params)
		return
	}

	if params.By != "" {
		a.searchAdvancedArtist(w, params)
		return
	}

	if params.Query != "" {
		a.searchAdvancedTracks(w, params)
		return
	}

	a.sendJSON(w, []byte("[]"))
}

func (app *app) searchAdvancedAlbum(w http.ResponseWriter, params advancedSearchParams) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*3)
	defer cancel()

	albums, err := app.client.Search(ctx, params.From, spotify.SearchTypeAlbum)
	if err != nil {
		app.sendInternalServerError(w, err)
		return
	}

	var album *spotify.SimpleAlbum
	for _, a := range albums.Albums.Albums {
		albumName := strings.ToLower(a.Name)
		query := strings.ToLower(params.From)
		var isArtist bool
		if params.By != "" {
			for _, art := range a.Artists {
				if strings.Contains(strings.ToLower(art.Name), strings.ToLower(params.By)) {
					isArtist = true
					break
				}
			}
		}

		if strings.Contains(albumName, query) && (isArtist || params.By == "") {
			album = &a
			break
		}
	}

	if album == nil {
		app.sendJSON(w, []byte("[]"))
		return
	}

	ctx, cancel = context.WithTimeout(context.Background(), time.Second*3)
	defer cancel()
	fullAlbum, err := app.client.GetAlbum(ctx, album.ID)
	if err != nil {
		app.sendInternalServerError(w, err)
		return
	}

	items := []item{}
	for _, t := range fullAlbum.Tracks.Tracks {
		if params.Query != "" && !strings.Contains(strings.ToLower(t.Name), strings.ToLower(params.Query)) {
			continue
		}

		items = append(items, item{
			ID:          string(t.ID),
			DisplayName: t.Name,
			Artist:      t.Artists[0].Name,
			Duration:    fmt.Sprintf("%d:%02d", (t.Duration/1000)/60, (t.Duration/1000)%60),
			Album:       album.Name,
		})
	}

	payload, err := json.Marshal(items)
	if err != nil {
		app.sendInternalServerError(w, err)
		return
	}

	app.sendJSON(w, payload)
}

func (app *app) searchAdvancedArtist(w http.ResponseWriter, params advancedSearchParams) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*3)
	defer cancel()

	tracks, err := app.client.Search(ctx, params.By, spotify.SearchTypeTrack)
	if err != nil {
		app.sendInternalServerError(w, err)
		return
	}

	items := []item{}
	for _, t := range tracks.Tracks.Tracks {
		isArtist := false
		for _, a := range t.Artists {
			if strings.Contains(strings.ToLower(a.Name), strings.ToLower(params.By)) {
				isArtist = true
				break
			}
		}

		if !isArtist {
			continue
		}

		if params.Query != "" && !strings.Contains(strings.ToLower(t.Name), strings.ToLower(params.Query)) {
			continue
		}

		items = append(items, item{
			ID:          string(t.ID),
			DisplayName: t.Name,
			Artist:      t.Artists[0].Name,
			Duration:    fmt.Sprintf("%d:%02d", (t.Duration/1000)/60, (t.Duration/1000)%60),
			Album:       t.Album.Name,
		})
	}

	payload, err := json.Marshal(items)
	if err != nil {
		app.sendInternalServerError(w, err)
		return
	}

	app.sendJSON(w, payload)
}

func (app *app) searchAdvancedTracks(w http.ResponseWriter, params advancedSearchParams) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*3)
	defer cancel()

	tracks, err := app.client.Search(ctx, params.Query, spotify.SearchTypeTrack)
	if err != nil {
		app.sendInternalServerError(w, err)
		return
	}

	items := []item{}
	for _, t := range tracks.Tracks.Tracks {
		if strings.Contains(strings.ToLower(t.Name), strings.ToLower(params.Query)) {
			items = append(items, item{
				ID:          string(t.ID),
				DisplayName: t.Name,
				Artist:      t.Artists[0].Name,
				Duration:    fmt.Sprintf("%d:%02d", (t.Duration/1000)/60, (t.Duration/1000)%60),
				Album:       t.Album.Name,
			})
		}
	}

	payload, err := json.Marshal(items)
	if err != nil {
		app.sendInternalServerError(w, err)
		return
	}

	app.sendJSON(w, payload)
}
