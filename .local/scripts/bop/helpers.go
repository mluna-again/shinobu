package main

import (
	"net/http"
)

func (app *app) sendInternalServerError(w http.ResponseWriter, err error) {
	app.errLogger.Error(err)

	w.WriteHeader(http.StatusInternalServerError)
	_, _ = w.Write([]byte(http.StatusText(http.StatusInternalServerError)))
}

func (app *app) sendInternalServerErrorWithMessage(w http.ResponseWriter, message string) {
	app.errLogger.Error(message)
	w.WriteHeader(http.StatusInternalServerError)
	_, _ = w.Write([]byte(message))
}

func (app *app) sendServerNotReadyError(w http.ResponseWriter) {
	app.errLogger.Error("Server not ready")
	w.WriteHeader(http.StatusInternalServerError)
	_, _ = w.Write([]byte("server says no (it's not ready 😳)"))
}

func (app *app) sendOk(w http.ResponseWriter) {
	w.WriteHeader(http.StatusOK)
	_, _ = w.Write([]byte("ok"))
}

func (app *app) sendNotFound(w http.ResponseWriter, r *http.Request) {
	app.errLogger.Errorf("%s Not Found", r.URL)

	w.WriteHeader(http.StatusNotFound)
	_, _ = w.Write([]byte(http.StatusText(http.StatusNotFound)))
}

func (app *app) sendContent(w http.ResponseWriter, content []byte) error {
	w.WriteHeader(http.StatusOK)
	_, err := w.Write([]byte(content))

	return err
}

func (app *app) sendJSON(w http.ResponseWriter, content []byte) {
	w.Header().Add("content-type", "application/json")
	w.WriteHeader(http.StatusOK)
	_, err := w.Write(content)

	if err != nil {
		app.sendInternalServerError(w, err)
	}
}

func (app *app) sendJSONWithStatus(w http.ResponseWriter, content []byte, code int) {
	w.Header().Add("content-type", "application/json")
	w.WriteHeader(code)
	_, err := w.Write(content)

	if err != nil {
		app.sendInternalServerError(w, err)
	}
}

func (app *app) sendBadRequestWithMessage(w http.ResponseWriter, content string) {
	app.errLogger.Errorf("Bad request: %s", content)
	w.WriteHeader(http.StatusBadRequest)
	_, _ = w.Write([]byte(content))
}
