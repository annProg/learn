package main

import "fmt"

func lengthOfLongestSubstring6(s string) int {
	l, r := 0, 0
	m := map[byte]int{}
	max := 0

	for r < len(s) {
		v := s[r]
		if _, ok := m[v]; ok && l <= m[v] {
			l = m[v] + 1
		}
		m[v] = r
		r++
		fmt.Println(l, r, max)
		if r-l > max {
			max = r - l
		}
	}
	return max
}

func main() {
	fmt.Println(lengthOfLongestSubstring6("abba"))
}
