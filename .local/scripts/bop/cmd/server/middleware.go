package server

import (
	"bytes"
	"errors"
	"io"
	"net/http"
)

func (app *app) loggingMiddleware(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		requestId := randomString()

		defer r.Body.Close()
		body, err := io.ReadAll(r.Body)
		if err != nil && !errors.Is(err, io.EOF) {
			app.logger.Infof("[%s] %s : ERROR PARSING BODY", requestId, r.URL)
			return
		}

		if string(body) == "" || errors.Is(err, io.EOF) {
			body = []byte("<empty>")
		}

		app.logger.Infof("[%s] %s : %s", requestId, r.URL, string(body))

		r.Body = io.NopCloser(bytes.NewBuffer(body))
		next(w, r)
	}
}

func (app *app) checkTokenMiddleware(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		if app.client == nil {
			app.sendInternalServerErrorWithMessage(w, "server says no (it's not ready)")
			return
		}

		next(w, r)
	}
}
