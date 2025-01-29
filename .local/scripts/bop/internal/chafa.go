package internal

import (
	"errors"
	"fmt"
	"os/exec"
	"strconv"
	"strings"
)

func GetChafaCmd(f string, size int) *exec.Cmd {
	major, minor, err := GetChafaVersion()
	if err == nil && major == 1 && minor < 14 {
		return exec.Command("chafa", "-f", "symbols", "-c", "full", "-s", fmt.Sprintf("%dx%d", size, size), f)
	}

	return exec.Command("chafa", "-f", "symbols", "-c", "full", "--polite", "on", "-s", fmt.Sprintf("%dx%d", size, size), f)
}

// returns major and minor version of chafa
//
// major, minor, err := GetChafaVersion()
func GetChafaVersion() (int, int, error) {
	output, err := exec.Command("chafa", "--version").CombinedOutput()
	if err != nil {
		return 0, 0, err
	}

	lines := strings.Split(string(output), "\n")
	if len(lines) == 0 {
		return 0, 0, errors.New("could not fetch chafa version")
	}

	firstLine := lines[0]
	cmps := strings.Split(firstLine, " ")
	if len(cmps) != 3 {
		return 0, 0, errors.New("unknown chafa version output")
	}

	version := strings.Split(cmps[2], ".")
	if len(version) != 3 {
		return 0, 0, errors.New("unknown chafa version output")
	}

	major, err := strconv.Atoi(version[0])
	if err != nil {
		return 0, 0, err
	}

	minor, err := strconv.Atoi(version[1])
	if err != nil {
		return 0, 0, err
	}

	return major, minor, nil
}
