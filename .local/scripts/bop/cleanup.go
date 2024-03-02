package main

import (
	"context"
	"os"
)

func (app *app) cleanup() {
	err := app.db.Close(context.Background())
	if err != nil {
		app.errLogger.Error("Could not close DB connection", err)
	} else {
		app.logger.Info("DB connection closed")
	}

	os.Exit(1)
}
