package main

import (
	"bytes"
	"errors"
	"io"
	"log"
	"net/http"
)

func logging(next http.HandlerFunc) http.HandlerFunc {
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
