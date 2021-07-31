package main

import "fmt"

func mySqrt(x int) int {
	if x < 2 {
		return x
	}
	left, right, res := 1, x, -1

	for left <= right {
		mid := left + (right-left)/2
		if mid*mid <= x {
			res = mid
			left = mid + 1
		} else {
			right = mid - 1
		}
	}
	return res
}

func main() {
	fmt.Println(mySqrt(8))
}
