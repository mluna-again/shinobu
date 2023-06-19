package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"

	"golang.org/x/term"
)

func main() {
	if len(os.Args) < 2 {
		os.Exit(1)
		return
	}

	w, _, err := term.GetSize(int(os.Stdin.Fd()))
	if err != nil {
		if len(os.Args) < 3 {
			fmt.Println(err.Error())
			os.Exit(1)
			return
		}
		wParam := os.Args[2]
		wParamInt, err := strconv.Atoi(wParam)
		if err != nil {
			fmt.Println(err.Error())
			os.Exit(1)
			return
		}
		w = wParamInt
	}

	p := os.Args[1]

	home := os.Getenv("HOME")

	if strings.TrimSpace(p) == strings.TrimSpace(home) {
		fmt.Print("~")
		return
	}

	if w < 100 {
		cmps := strings.Split(p, "/")
		fmt.Print(cmps[len(cmps)-1])
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
