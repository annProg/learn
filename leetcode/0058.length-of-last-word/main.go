package main

import "fmt"

func lengthOfLastWord(s string) int {
	if len(s) == 0 {
		return 0
	}
	for i := 0; i < len(s); i++ {
		if s[i] != ' ' {
			break
		}
	}
	n := 0
	for i := len(s) - 1; i >= 0; i-- {
		if s[i] != ' ' {
			n++
		} else if n > 0 {
			break
		}
	}
	return n
}

func main() {
	fmt.Println(lengthOfLastWord("hellow world"))
}
