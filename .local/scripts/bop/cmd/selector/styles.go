package selector

import "github.com/charmbracelet/lipgloss"

var yellow = lipgloss.Color("#d9cf48")
var red = lipgloss.Color("#f54251")
var black = lipgloss.Color("#1D1C19")
var darkerBlack = lipgloss.Color("#282727")
var gray = lipgloss.Color("#a6a69c")
var white = lipgloss.Color("#c5c9c5")

var songItemS = lipgloss.NewStyle().
	Height(3).
	AlignVertical(lipgloss.Center).
	Background(darkerBlack)

var songItemSelectedS = lipgloss.NewStyle().
	Height(3).
	AlignVertical(lipgloss.Center).
	Background(black).
	Foreground(red)

var songCellS = lipgloss.NewStyle().
	AlignHorizontal(lipgloss.Center).
	Foreground(gray).
	Background(darkerBlack)

var songCellSelectedS = lipgloss.NewStyle().
	AlignHorizontal(lipgloss.Center).
	Foreground(gray).
	Background(black)

var songHeaderS = lipgloss.NewStyle().
	Height(3).
	AlignVertical(lipgloss.Center).
	Background(darkerBlack)

var songColS = lipgloss.NewStyle().
	AlignHorizontal(lipgloss.Center).
	Background(darkerBlack)

var songViewportS = lipgloss.NewStyle().
	Background(darkerBlack)

var songViewportHeaderS = lipgloss.NewStyle().
	Background(darkerBlack).
	Height(3).
	AlignVertical(lipgloss.Center)

var bg = black

var inputS = lipgloss.NewStyle().
	Background(bg).
	PaddingTop(1).
	PaddingBottom(1).
	PaddingLeft(1)

var promptS = lipgloss.NewStyle().
	Background(red).
	AlignVertical(lipgloss.Center).
	Height(3)

var textS = lipgloss.NewStyle().
	Background(black).
	Foreground(white)

var placeholderS = lipgloss.NewStyle().
	Background(black).
	Foreground(gray)

var cursorS = lipgloss.NewStyle().
	Background(black).
	Foreground(gray)

var helpInfo = lipgloss.NewStyle().
	Background(darkerBlack)

var helpRInfo = lipgloss.NewStyle().
	Background(darkerBlack).
	AlignHorizontal(lipgloss.Right)

var helpLInfo = lipgloss.NewStyle().
	Background(darkerBlack)

var bannerS = lipgloss.NewStyle().
	Background(darkerBlack).
	AlignVertical(lipgloss.Center)
