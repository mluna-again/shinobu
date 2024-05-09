package server

import (
	"flag"
	"os"

	"github.com/charmbracelet/log"

	"errors"

	"github.com/jackc/pgx/v5"
	"github.com/zmb3/spotify/v2"
)

type app struct {
	results       *spotify.SearchResult
	client        *spotify.Client
	helpRequested bool
	clientId      string
	secret        string
	db            *pgx.Conn
	logger        *log.Logger
	errLogger     *log.Logger
}

var (
	noClientError = errors.New("No SPOTIFY_ID found")
	noSecretError = errors.New("No SPOTIFY_SECRET found")
)

var cmdFlag string
var helpFlag bool
var queryFlag string

func initializeApp() (*app, error) {
	clientId := os.Getenv("SPOTIFY_ID")
	if clientId == "" {
		return nil, noClientError
	}

	secret := os.Getenv("SPOTIFY_SECRET")
	if secret == "" {
		return nil, noSecretError
	}

	flag.StringVar(&cmdFlag, "command", "search", "action")
	flag.BoolVar(&helpFlag, "help", false, "display help")
	flag.StringVar(&queryFlag, "query", "", "query")
	flag.Parse()

	l, errL := newLogger()
	conn, err := newDb()
	if err != nil {
		l.Infof("Could not connect to database: %s\n", err.Error())
	}

	a := &app{
		helpRequested: helpFlag,
		clientId:      clientId,
		secret:        secret,
		db:            conn,
		logger:        l,
		errLogger:     errL,
	}

	return a, nil
}
