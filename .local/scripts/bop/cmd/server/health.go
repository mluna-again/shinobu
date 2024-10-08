package server

import (
	"encoding/json"
	"net/http"
)

func (a *app) health(w http.ResponseWriter, r *http.Request) {
	if a.client == nil {
		response, err := json.Marshal(map[string]string{"message": "auth not ready"})
		if err != nil {
			a.sendInternalServerError(w, err)
			return
		}

		a.sendJSONWithStatus(w, response, http.StatusForbidden)
		return
	}
	w.WriteHeader(http.StatusOK)
}
