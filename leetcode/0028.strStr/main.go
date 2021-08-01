package main

import "fmt"

func strStr(haystack string, needle string) int {
	n := 0
	if len(needle) == 0 {
		return n
	}
	if len(haystack) == 0 {
		return -1
	}

	left, right := 0, 0
	for right < len(haystack) {
		if haystack[right] != needle[right-left] {
			left++
			right = left
		} else if right-left == len(needle)-1 {
			return left
		} else {
			right++
		}
	}
	return -1
}

func main() {
	fmt.Println(strStr("ippi", "ipi"))
}
