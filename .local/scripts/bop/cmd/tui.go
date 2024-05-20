package cmd

import (
	"bop/cmd/selector"
	"fmt"
	"os"

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

func init() {
	rootCmd.AddCommand(tuiCmd)

	selectCmd.Flags().BoolP("dev", "d", false, "dev mode (doesn't queue songs)")
	tuiCmd.AddCommand(selectCmd)
}
