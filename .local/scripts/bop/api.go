package main

import (
	"encoding/json"
	"net/http"
	"strings"
)

// i just got lazy and didn't want to split this "small" functions in different files ok

func (app *app) pause(w http.ResponseWriter, r *http.Request) {
	if app.client == nil {
		sendServerNotReadyError(w)
		return
	}

	err := app.client.Play(r.Context())
	if err != nil {
		// maybe player is already playing (i guess there is a way to tell spotify to toggle it but idk how)
		if strings.Contains(err.Error(), "Restriction violated") {
			err := app.client.Pause(r.Context())
			if err != nil {
				sendInternalServerErrorWithMessage(w, err.Error())
				return
			}
			sendOk(w)
			return
		}
		sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	sendOk(w)
}

func (app *app) next(w http.ResponseWriter, r *http.Request) {
	if app.client == nil {
		sendServerNotReadyError(w)
		return
	}

	err := app.client.Next(r.Context())
	if err != nil {
		sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	sendOk(w)
}

func (app *app) prev(w http.ResponseWriter, r *http.Request) {
	if app.client == nil {
		sendServerNotReadyError(w)
		return
	}

	err := app.client.Previous(r.Context())
	if err != nil {
		sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	sendOk(w)
}

func (app *app) status(w http.ResponseWriter, r *http.Request) {
	if app.client == nil {
		sendServerNotReadyError(w)
		return
	}

	info, err := app.client.PlayerCurrentlyPlaying(r.Context())
	if err != nil {
		sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	if info.Item == nil {
		sendNotFound(w)
		return
	}

	response := item{
		DisplayName: info.Item.Name,
		ID:          string(info.Item.ID),
		Artist:      info.Item.Artists[0].Name,
	}

	output, err := json.Marshal(response)
	if err != nil {
		sendInternalServerError(w)
		return
	}

	_ = sendContent(w, output)
}

func (app *app) restart(w http.ResponseWriter, r *http.Request) {
	err := app.client.Seek(r.Context(), 0)
	if err != nil {
		sendInternalServerErrorWithMessage(w, err.Error())
		return
	}

	sendOk(w)
}

func (app *app) queue(w http.ResponseWriter, r *http.Request) {
	q, err := app.client.GetQueue(r.Context())
	if err != nil {
		sendInternalServerErrorWithMessage(w, err.Error())
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
		})
	}

	output, err := json.Marshal(items)
	if err != nil {
		sendInternalServerErrorWithMessage(w, err.Error())
		return
	}
	_ = sendContent(w, output)
}
