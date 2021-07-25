package main

import "fmt"

func firstUniqChar(s string) int {
	m := map[byte]int{}
	min := -1

	for i := 0; i < len(s); i++ {
		m[s[i]] += 1
	}
	for i := 0; i < len(s); i++ {
		if m[s[i]] == 1 {
			return i
		}
	}
	return min
}

func main() {
	fmt.Println(firstUniqChar("dddccdbba"))
	fmt.Println(firstUniqChar("loveleetcode"))
}
