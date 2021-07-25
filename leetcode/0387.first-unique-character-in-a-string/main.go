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

func firstUniqChar2(s string) int {
	cnt := [26]int{}
	for _, ch := range s {
		cnt[ch-'a']++
	}
	for i, ch := range s {
		if cnt[ch-'a'] == 1 {
			return i
		}
	}
	return -1
}

func main() {
	fmt.Println(firstUniqChar("dddccdbba"))
	fmt.Println(firstUniqChar("loveleetcode"))
}
