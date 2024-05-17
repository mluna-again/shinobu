package cmd

import (
	"bop/cmd/selector"

	"github.com/spf13/cobra"
)

var tuiCmd = &cobra.Command{
	Use:   "tui",
	Short: "tui interfaces",
}

var selectCmd = &cobra.Command{
	Use:   "select",
	Short: "opens a selector for queueing multiple songs at once",
	Run: func(cmd *cobra.Command, args []string) {
		selector.Run()
	},
}

func init() {
	rootCmd.AddCommand(tuiCmd)
	tuiCmd.AddCommand(selectCmd)
}
