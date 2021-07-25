package main

import "fmt"

func isAnagram(s string, t string) bool {
	if len(s) != len(t) {
		return false
	}
	m := [26]int{}

	for _, ch := range s {
		m[ch-'a']++
	}

	for _, ch := range t {
		if m[ch-'a'] == 0 {
			return false
		}
		m[ch-'a']--
	}
	return true
}

func main() {
	fmt.Println(isAnagram("ab", "ba"))
}
