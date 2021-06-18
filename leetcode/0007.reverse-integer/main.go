package main

import "fmt"

func reverse(x int) int {
	ret := 0
	for x != 0 {
		ret = 10*ret + x%10
		x = x / 10
	}
	if ret < -1*1<<31 || ret > 1<<31-1 {
		return 0
	}
	return ret
}

func main() {
	fmt.Println(reverse(123))
	fmt.Println(reverse(-123))
	fmt.Println(reverse(0))
}
