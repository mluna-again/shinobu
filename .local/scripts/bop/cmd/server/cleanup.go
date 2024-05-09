package server

import (
	"context"
)

func (app *app) cleanup() {
	err := app.db.Close(context.Background())
	if err != nil {
		app.errLogger.Error("Could not close DB connection", err)
	} else {
		app.logger.Info("DB connection closed")
	}
}
