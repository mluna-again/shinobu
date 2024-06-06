package main

import (
	"flag"
	"fmt"
	"os"
	"strconv"
	"strings"
	"unicode/utf8"

	"golang.org/x/term"
)

var MAX_PATH_SIZE int

func main() {
	flag.IntVar(&MAX_PATH_SIZE, "maxlen", 30, "maximum length before trim")
	flag.Parse()

	args := flag.Args()
	if len(args) < 1 {
		os.Exit(1)
		return
	}

	w, _, err := term.GetSize(int(os.Stdin.Fd()))
	if err != nil {
		if len(args) < 2 {
			fmt.Println(err.Error())
			os.Exit(1)
			return
		}
		wParam := args[1]
		wParamInt, err := strconv.Atoi(wParam)
		if err != nil {
			fmt.Println(err.Error())
			os.Exit(1)
			return
		}
		w = wParamInt
	}

	p := args[0]

	home := os.Getenv("HOME")

	if strings.TrimSpace(p) == strings.TrimSpace(home) {
		fmt.Print("~")
		return
	}

	if w < 100 {
		cmps := strings.Split(p, string(os.PathSeparator))
		fmt.Print(cutIfTooLong(cmps[len(cmps)-1]))
		return
	}

	relativeP, _ := strings.CutPrefix(p, fmt.Sprintf("%s%c", home, os.PathSeparator))

	slashCount := strings.Count(relativeP, string(os.PathSeparator))

	if slashCount < 2 {
		fmt.Printf("~%c%s", os.PathSeparator, cutIfTooLong(relativeP))
		return
	}

	components := strings.Split(relativeP, string(os.PathSeparator))
	lastComps := components[len(components)-2:]
	newP := strings.Join(lastComps, string(os.PathSeparator))
	fmt.Print(cutIfTooLong(newP))
}

func cutIfTooLong(p string) string {
	runeCount := utf8.RuneCount([]byte(p))
	if runeCount > MAX_PATH_SIZE {
		c := string([]rune(p)[runeCount-MAX_PATH_SIZE:])

		return fmt.Sprintf("...%s", c)
	}

	return p
}
