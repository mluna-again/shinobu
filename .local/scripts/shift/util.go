package main

func shouldGoToTop(msg string) bool {
	ignore := []string{"ctrl+n", "ctrl+p", "up", "down", "tab", "shift+tab"}
	for _, s := range ignore {
		if s == msg {
			return false
		}
	}

	return true
}
