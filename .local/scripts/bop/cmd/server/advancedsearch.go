package server

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strings"
	"time"

	"github.com/zmb3/spotify/v2"
)

const SPOTIFY_PAGE_SIZE = 50

type advancedSearchParams struct {
	Query  string `json:"query"`
	From   string `json:"from"`
	By     string `json:"by"`
	Page   int    `json:"page"`
	Offset int
	Liked  bool
	Latest bool
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
	params.parseTags()
	params.Offset = (params.Page - 1) * SPOTIFY_PAGE_SIZE
	if params.Offset < 0 {
		params.Offset = 0
	}

	if params.Latest {
		a.searchAdvancedTags(w, params)
		return
	}

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

	albums, err := app.client.Search(ctx, params.From, spotify.SearchTypeAlbum, spotify.Limit(SPOTIFY_PAGE_SIZE), spotify.Offset(params.Offset))
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

	ids := []spotify.ID{}
	for _, t := range fullAlbum.Tracks.Tracks {
		ids = append(ids, t.ID)
	}
	liked, err := app.client.UserHasTracks(ctx, ids...)
	if err != nil {
		app.sendInternalServerError(w, err)
		return
	}
	if len(liked) != len(fullAlbum.Tracks.Tracks) {
		app.sendInternalServerError(w, errors.New("not enough liked songs to compare!"))
		return
	}

	items := []item{}
	for i, t := range fullAlbum.Tracks.Tracks {
		if params.Query != "" && !strings.Contains(strings.ToLower(t.Name), strings.ToLower(params.Query)) {
			continue
		}

		if params.Liked && !liked[i] {
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

	tracks, err := app.client.Search(ctx, params.By, spotify.SearchTypeTrack, spotify.Limit(SPOTIFY_PAGE_SIZE), spotify.Offset(params.Offset))
	if err != nil {
		app.sendInternalServerError(w, err)
		return
	}

	ids := []spotify.ID{}
	for _, t := range tracks.Tracks.Tracks {
		ids = append(ids, t.ID)
	}
	liked, err := app.client.UserHasTracks(ctx, ids...)
	if err != nil {
		app.sendInternalServerError(w, err)
		return
	}
	if len(liked) != len(tracks.Tracks.Tracks) {
		app.sendInternalServerError(w, errors.New("not enough liked songs to compare!"))
		return
	}

	items := []item{}
	for i, t := range tracks.Tracks.Tracks {
		isArtist := false
		for _, a := range t.Artists {
			if strings.Contains(strings.ToLower(a.Name), strings.ToLower(params.By)) {
				isArtist = true
				break
			}
		}

		if params.Liked && !liked[i] {
			continue
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

	tracks, err := app.client.Search(ctx, params.Query, spotify.SearchTypeTrack, spotify.Limit(SPOTIFY_PAGE_SIZE), spotify.Offset(params.Offset))
	if err != nil {
		app.sendInternalServerError(w, err)
		return
	}

	ids := []spotify.ID{}
	for _, t := range tracks.Tracks.Tracks {
		ids = append(ids, t.ID)
	}
	liked, err := app.client.UserHasTracks(ctx, ids...)
	if err != nil {
		app.sendInternalServerError(w, err)
		return
	}
	if len(liked) != len(tracks.Tracks.Tracks) {
		app.sendInternalServerError(w, errors.New("not enough liked songs to compare!"))
		return
	}

	items := []item{}
	for i, t := range tracks.Tracks.Tracks {
		if params.Liked && !liked[i] {
			continue
		}

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

func (app *app) searchAdvancedTags(w http.ResponseWriter, params advancedSearchParams) {
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*4)
	defer cancel()

	tracks, err := app.client.CurrentUsersTracks(ctx, spotify.Limit(SPOTIFY_PAGE_SIZE), spotify.Offset(params.Offset))
	if err != nil {
		app.sendInternalServerError(w, err)
		return
	}

	ids := []spotify.ID{}
	for _, t := range tracks.Tracks {
		ids = append(ids, t.ID)
	}
	liked, err := app.client.UserHasTracks(ctx, ids...)
	if err != nil {
		app.sendInternalServerError(w, err)
		return
	}
	if len(liked) != len(tracks.Tracks) {
		app.sendInternalServerError(w, errors.New("not enough liked songs to compare!"))
		return
	}

	items := []item{}
	for i, t := range tracks.Tracks {
		if params.Liked && !liked[i] {
			continue
		}

		if params.From != "" && !sSongFrom(t, params.From) {
			continue
		}

		if params.By != "" && !sSongBy(t, params.By) {
			continue
		}

		if params.Query != "" && !sSongQueried(t, params.Query) {
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
