package main

import (
	"bytes"
	"errors"
	"io"
	"log"
	"net/http"
)

func loggingMiddleware(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		requestId := randomString()

		defer r.Body.Close()
		body, err := io.ReadAll(r.Body)
		if err != nil && !errors.Is(err, io.EOF) {
			log.Printf("[%s] %s : ERROR PARSING BODY", requestId, r.URL)
			return
		}

		if string(body) == "" || errors.Is(err, io.EOF) {
			body = []byte("<empty>")
		}

		log.Printf("[%s] %s : %s", requestId, r.URL, string(body))

		r.Body = io.NopCloser(bytes.NewBuffer(body))
		next(w, r)
	}
}

func (app *app) checkTokenMiddleware(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		if app.client == nil {
			sendInternalServerErrorWithMessage(w, "server says no (it's not ready)")
			return
		}

		next(w, r)
	}
}
