package cmd

import (
	"bop/cmd/queueview"
	"bop/cmd/selector"
	"bop/internal/bubbles"
	"fmt"
	"os"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/spf13/cobra"
)

var tuiCmd = &cobra.Command{
	Use:   "tui",
	Short: "tui interfaces",
}

var selectCmd = &cobra.Command{
	Use:   "select",
	Short: "opens a selector for queueing multiple songs at once",
	Long: `select
Possible error codes:
0. No errors. New items in queue.
1. No errors. No new items in queue.
2. Error. No new items in queue.
	`,
	Run: func(cmd *cobra.Command, args []string) {
		dev, err := cmd.Flags().GetBool("dev")
		if err != nil {
			fmt.Fprintf(os.Stderr, "%s\n", err.Error())
			os.Exit(2)
		}

		config := selector.SelectorConfig{
			DevMode: dev,
		}
		selector.Run(config)
	},
}

var queueCmd = &cobra.Command{
	Use:   "queue",
	Short: "displays the current queue in a pretty table",
	Run: func(cmd *cobra.Command, args []string) {
		queueview.Run()
	},
}

var playerCmd = &cobra.Command{
	Use:   "player",
	Short: "player :D",
	Run: func(cmd *cobra.Command, args []string) {
		m := bubbles.NewPlayer(0, 130)
		p := tea.NewProgram(m, tea.WithAltScreen())
		if _, err := p.Run(); err != nil {
			fmt.Println("Oh no!", err)
			os.Exit(1)
		}
	},
}

func init() {
	rootCmd.AddCommand(tuiCmd)

	selectCmd.Flags().BoolP("dev", "d", false, "dev mode (doesn't queue songs)")
	tuiCmd.AddCommand(selectCmd)
	tuiCmd.AddCommand(queueCmd)
	tuiCmd.AddCommand(playerCmd)
}
