package server

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/zmb3/spotify/v2"
)

// i just got lazy and didn't want to split this "small" functions in different files ok

func (app *app) pause(w http.ResponseWriter, r *http.Request) {
	if app.client == nil {
		app.sendServerNotReadyError(w)
		return
	}

	state, err := app.client.PlayerState(r.Context())
	if err != nil {
		app.sendInternalServerError(w, err)
		return
	}

	if state.Playing {
		err = app.client.Pause(r.Context())
	} else {
		err = app.client.Play(r.Context())
	}

	if err != nil {
		app.sendInternalServerError(w, err)
		return
	}

	app.sendOk(w)
}

func (app *app) next(w http.ResponseWriter, r *http.Request) {
	if app.client == nil {
		app.sendServerNotReadyError(w)
		return
	}

	err := app.client.Next(r.Context())
	if err != nil {
		app.sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	app.sendOk(w)
}

func (app *app) prev(w http.ResponseWriter, r *http.Request) {
	if app.client == nil {
		app.sendServerNotReadyError(w)
		return
	}

	err := app.client.Previous(r.Context())
	if err != nil {
		app.sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	app.sendOk(w)
}

func (app *app) status(w http.ResponseWriter, r *http.Request) {
	if app.client == nil {
		app.sendServerNotReadyError(w)
		return
	}

	info, err := app.client.PlayerCurrentlyPlaying(r.Context())
	if err != nil {
		app.sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	if info.Item == nil {
		app.sendNotFound(w, r)
		return
	}

	response := item{
		DisplayName:   info.Item.Name,
		ID:            string(info.Item.ID),
		Artist:        info.Item.Artists[0].Name,
		ImageUrl:      info.Item.Album.Images[0].URL,
		TotalSeconds:  info.Item.Duration / 1000,
		CurrentSecond: info.Progress / 1000,
		IsPlaying:     info.Playing,
		Album:         info.Item.Album.Name,
	}

	output, err := json.Marshal(response)
	if err != nil {
		app.sendInternalServerError(w, err)
		return
	}

	app.sendJSON(w, output)
}

func (app *app) restart(w http.ResponseWriter, r *http.Request) {
	err := app.client.Seek(r.Context(), 0)
	if err != nil {
		app.sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	app.sendOk(w)
}

func (app *app) queue(w http.ResponseWriter, r *http.Request) {
	q, err := app.client.GetQueue(r.Context())
	if err != nil {
		app.sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	items := []item{}

	for index, i := range q.Items {
		if index > 20 {
			break
		}
		items = append(items, item{
			ID:          string(i.ID),
			DisplayName: i.Name,
			Artist:      i.Artists[0].Name,
			ImageUrl:    i.Album.Images[0].URL,
			Duration:    fmt.Sprintf("%d:%02d", (i.Duration/1000)/60, (i.Duration/1000)%60),
			Album:       i.Album.Name,
		})
	}

	output, err := json.Marshal(items)
	if err != nil {
		app.sendInternalServerErrorWithMessage(w, err.Error())
		return
	}
	app.sendJSON(w, output)
}

type addToQueueParams struct {
	IDS []string `json:"ids"`
}

func (app *app) addToQueue(w http.ResponseWriter, r *http.Request) {
	var data addToQueueParams
	d := json.NewDecoder(r.Body)
	err := d.Decode(&data)
	if err != nil {
		app.sendBadRequestWithMessage(w, "invalid params")
		return
	}
	defer r.Body.Close()

	ids := []spotify.ID{}
	for _, i := range data.IDS {
		ids = append(ids, spotify.ID(i))
	}
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*3)
	defer cancel()
	tracks, err := app.client.GetTracks(ctx, ids)
	if err != nil {
		app.sendBadRequestWithMessage(w, err.Error())
		return
	}

	if len(tracks) == 0 {
		app.sendOk(w)
		return
	}

	firstSong := tracks[0]
	err = app.client.QueueSong(ctx, firstSong.ID)
	if err != nil {
		app.sendBadRequestWithMessage(w, err.Error())
		return
	}

	if len(tracks) == 1 {
		app.sendOk(w)
		return
	}

	remaining := tracks[1:]
	go func(tracks []*spotify.FullTrack) {
		for _, song := range tracks {
			ctx, cancel := context.WithTimeout(context.Background(), time.Second*3)
			defer cancel()
			err := app.client.QueueSong(ctx, song.ID)
			if err != nil {
				app.errLogger.Error(err)
				return
			}
			time.Sleep(time.Millisecond * 1500)
		}
	}(remaining)

	app.sendOk(w)
}

type addToLikedParams struct {
	ID string `json:"id"`
}

func (app *app) addToLiked(w http.ResponseWriter, r *http.Request) {
	var params addToLikedParams
	d := json.NewDecoder(r.Body)
	err := d.Decode(&params)
	if err != nil {
		app.sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	id := params.ID
	if id == "" {
		info, err := app.client.PlayerCurrentlyPlaying(r.Context())
		if err != nil {
			app.sendInternalServerErrorWithMessage(w, err.Error())
			return
		}

		id = string(info.Item.ID)
	}
	err = app.client.AddTracksToLibrary(r.Context(), spotify.ID(id))
	if err != nil {
		app.sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	app.sendOk(w)
}

type removeFromLikedParams struct {
	ID string `json:"id"`
}

func (app *app) removeFromLiked(w http.ResponseWriter, r *http.Request) {
	var params removeFromLikedParams
	d := json.NewDecoder(r.Body)
	err := d.Decode(&params)
	if err != nil {
		app.sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	id := params.ID
	if id == "" {
		info, err := app.client.PlayerCurrentlyPlaying(r.Context())
		if err != nil {
			app.sendInternalServerErrorWithMessage(w, err.Error())
			return
		}

		id = string(info.Item.ID)
	}

	err = app.client.RemoveTracksFromLibrary(r.Context(), spotify.ID(id))
	if err != nil {
		app.sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	app.sendOk(w)
}

type device struct {
	ID   string `json:"id"`
	Name string `json:"name"`
	Type string `json:"type"`
}

func (app *app) listDevices(w http.ResponseWriter, r *http.Request) {
	devs, err := app.client.PlayerDevices(r.Context())
	if err != nil {
		app.sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	resp := []device{}
	for _, dev := range devs {
		resp = append(resp, device{
			ID:   dev.ID.String(),
			Name: dev.Name,
			Type: dev.Type,
		})
	}

	data, err := json.Marshal(resp)
	if err != nil {
		app.sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	app.sendJSON(w, data)
}

type setDeviceReq struct {
	ID   string `json:"id"`
	Play *bool  `json:"play"`
}

func (app *app) setDevice(w http.ResponseWriter, r *http.Request) {
	decoder := json.NewDecoder(r.Body)
	defer r.Body.Close()

	data := setDeviceReq{}
	err := decoder.Decode(&data)
	if err != nil {
		app.sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	if data.ID == "" {
		app.sendBadRequestWithMessage(w, "missing ID")
		return
	}

	play := true
	if data.Play != nil {
		play = *data.Play
	}
	err = app.client.TransferPlayback(r.Context(), spotify.ID(data.ID), play)
	if err != nil {
		app.sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	app.sendOk(w)
}
