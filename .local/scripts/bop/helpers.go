package main

import "net/http"

func sendInternalServerError(w http.ResponseWriter) {
	w.WriteHeader(http.StatusInternalServerError)
	_, _ = w.Write([]byte(http.StatusText(http.StatusInternalServerError)))
}

func sendInternalServerErrorWithMessage(w http.ResponseWriter, message string) {
	w.WriteHeader(http.StatusInternalServerError)
	_, _ = w.Write([]byte(message))
}

func sendServerNotReadyError(w http.ResponseWriter) {
	w.WriteHeader(http.StatusInternalServerError)
	_, _ = w.Write([]byte("server says no (it's not ready 😳)"))
}

func sendOk(w http.ResponseWriter) {
	w.WriteHeader(http.StatusOK)
	_, _ = w.Write([]byte("ok"))
}

func sendNotFound(w http.ResponseWriter) {
	w.WriteHeader(http.StatusNotFound)
	_, _ = w.Write([]byte(http.StatusText(http.StatusNotFound)))
}

func sendContent(w http.ResponseWriter, content []byte) error {
	w.WriteHeader(http.StatusOK)
	_, err := w.Write([]byte(content))

	return err
}
