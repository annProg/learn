package main

import "fmt"

func reverseString(s []byte) {
	l := 0
	r := len(s) - 1
	for l < r {
		s[l], s[r] = s[r], s[l]
		l++
		r--
	}
}

func main() {
	s := []byte{'a', 'b', 'c', 'd'}
	reverseString(s)
	fmt.Println(s)
}
