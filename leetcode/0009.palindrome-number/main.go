package main

import "fmt"

func isPalindrome(x int) bool {
	if x < 0 {
		return false
	}
	ret := reverse(x)
	if x == ret {
		return true
	}
	return false
}

func reverse(x int) int {
	ret := 0
	for x != 0 {
		ret = 10*ret + x%10
		x = x / 10
	}
	return ret
}

func main() {
	fmt.Println(isPalindrome(121))
	fmt.Println(isPalindrome(122))
}
