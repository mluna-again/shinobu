package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	if len(os.Args) < 2 {
		os.Exit(1)
		return
	}

	p := os.Args[1]

	home := os.Getenv("HOME")

	if strings.TrimSpace(p) == strings.TrimSpace(home) {
		fmt.Print("~")
		return
	}

	relativeP, _ := strings.CutPrefix(p, fmt.Sprintf("%s/", home))

	slashCount := strings.Count(relativeP, "/")

	if slashCount < 2 {
		fmt.Printf("~/%s", relativeP)
		return
	}

	components := strings.Split(relativeP, "/")
	lastComps := components[len(components)-2:]
	newP := strings.Join(lastComps, "/")
	fmt.Print(newP)
}
