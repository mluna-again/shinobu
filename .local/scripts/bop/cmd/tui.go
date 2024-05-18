package cmd

import (
	"bop/cmd/selector"
	"log"

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
		dev, err := cmd.Flags().GetBool("dev")
		if err != nil {
			log.Fatal(err)
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
