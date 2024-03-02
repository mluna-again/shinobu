package main

import (
	"os"

	"github.com/charmbracelet/lipgloss"
	"github.com/charmbracelet/log"
)

func newLogger() (*log.Logger, *log.Logger) {
	styles := log.DefaultStyles()
	styles.Levels[log.ErrorLevel] = lipgloss.NewStyle().
		SetString("ERROR").
		Padding(0, 1, 0, 1).
		Background(lipgloss.Color("160")).
		Foreground(lipgloss.Color("0"))

	styles.Levels[log.InfoLevel] = lipgloss.NewStyle().
		SetString("INFO").
		Padding(0, 1, 0, 1).
		Background(lipgloss.Color("033")).
		Foreground(lipgloss.Color("0"))

	styles.Levels[log.DebugLevel] = lipgloss.NewStyle().
		SetString("DEBUG").
		Padding(0, 1, 0, 1).
		Background(lipgloss.Color("225")).
		Foreground(lipgloss.Color("0"))

	styles.Levels[log.WarnLevel] = lipgloss.NewStyle().
		SetString("WARNING").
		Padding(0, 1, 0, 1).
		Background(lipgloss.Color("208")).
		Foreground(lipgloss.Color("0"))

	logger := log.New(os.Stdout)
	logger.SetStyles(styles)
	logger.SetReportTimestamp(true)

	errLogger := log.New(os.Stderr)

	return logger, errLogger
}
