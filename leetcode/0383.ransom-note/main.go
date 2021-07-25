package main

import "fmt"

func canConstruct(ransomNote string, magazine string) bool {
	m := [26]int{}
	for _, ch := range magazine {
		m[ch-'a']++
	}

	for _, ch := range ransomNote {
		if m[ch-'a'] == 0 {
			return false
		}
		m[ch-'a']--
	}
	return true
}

func main() {
	fmt.Println(canConstruct("aa", "aab"))
}
