package internal

func IndexOf[T any](s []T, fn func(T) bool) int {
	for i, it := range s {
		if fn(it) {
			return i
		}
	}

	return -1
}
