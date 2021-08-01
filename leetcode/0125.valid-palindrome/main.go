package main

import "fmt"

func isPalindrome(s string) bool {
	if len(s) == 0 {
		return true
	}
	L, R := 0, len(s)-1
	for L < R {
		if !isAlphaDigit(s[L]) {
			L++
			continue
		}
		if !isAlphaDigit(s[R]) {
			R--
			continue
		}
		chl := upper(s[L])
		chr := upper(s[R])
		if chl == chr {
			L++
			R--
		} else {
			return false
		}
	}
	return true
}

func isAlphaDigit(ch byte) bool {
	if ch-'0' < 10 && ch-'0' >= 0 {
		return true
	}
	if ch-'a' >= 0 && ch-'a' < 26 {
		return true
	}
	if ch-'A' >= 0 && ch-'A' < 26 {
		return true
	}
	return false
}

func upper(ch byte) byte {
	if ch-'a' >= 0 && ch-'a' < 26 {
		return ch - 32
	}
	return ch
}

func main() {
	fmt.Println(isPalindrome("A man, a plan, a canal: Panama"))
}
