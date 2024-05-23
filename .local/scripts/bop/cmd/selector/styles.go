package selector

import "github.com/charmbracelet/lipgloss"

var songItemS = lipgloss.NewStyle().
	Height(3).
	AlignVertical(lipgloss.Center)

var songItemSelectedS = lipgloss.NewStyle().
	Height(3).
	AlignVertical(lipgloss.Center)

var songSelColS = lipgloss.NewStyle().
	AlignHorizontal(lipgloss.Center)

var songSelColSelectedS = lipgloss.NewStyle().
	AlignHorizontal(lipgloss.Center)

var songCellS = lipgloss.NewStyle().
	AlignHorizontal(lipgloss.Center)

var songCellSelectedS = lipgloss.NewStyle().
	AlignHorizontal(lipgloss.Center)

var songHeaderS = lipgloss.NewStyle().
	Height(3).
	AlignVertical(lipgloss.Center)

var songColS = lipgloss.NewStyle().
	AlignHorizontal(lipgloss.Center)

var songViewportS = lipgloss.NewStyle()

var songViewportHeaderS = lipgloss.NewStyle().
	Height(3).
	AlignVertical(lipgloss.Center)

var inputS = lipgloss.NewStyle().
	PaddingTop(1).
	PaddingBottom(1).
	PaddingLeft(1)

var promptS = lipgloss.NewStyle().
	AlignVertical(lipgloss.Center).
	Height(3)

var textS = lipgloss.NewStyle()

var placeholderS = lipgloss.NewStyle()

var cursorS = lipgloss.NewStyle()

var helpInfo = lipgloss.NewStyle()

var helpRInfo = lipgloss.NewStyle().
	AlignHorizontal(lipgloss.Right)

var helpLInfo = lipgloss.NewStyle()

var bannerS = lipgloss.NewStyle().
	AlignVertical(lipgloss.Center)

var bannerWithHelpS = lipgloss.NewStyle().
	AlignVertical(lipgloss.Center)

var bannerBGS = lipgloss.NewStyle()

var queueSongComptS = lipgloss.NewStyle().
	AlignHorizontal(lipgloss.Center).
	AlignVertical(lipgloss.Center).
	Height(3)

var queueSongComptSelectedS = lipgloss.NewStyle().
	AlignHorizontal(lipgloss.Center).
	AlignVertical(lipgloss.Center).
	Height(3)

var queueHeaderComptS = lipgloss.NewStyle().
	AlignHorizontal(lipgloss.Center).
	AlignVertical(lipgloss.Center).
	Height(3)

var queueViewportS = lipgloss.NewStyle()
