package main

import "fmt"

func romanToInt(s string) int {
	m := map[byte]int{'I': 1, 'V': 5, 'X': 10, 'L': 50, 'C': 100, 'D': 500, 'M': 1000}
	r := 0
	l := len(s)

	for i := range s {
		if i < l-1 && m[s[i]] < m[s[i+1]] {
			r -= m[s[i]]
		} else {
			r += m[s[i]]
		}
	}
	return r
}
func main() {
	fmt.Println(romanToInt("IV"))
}
