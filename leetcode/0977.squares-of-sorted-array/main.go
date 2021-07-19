package main

import "fmt"

func sortedSquares(nums []int) []int {
	n1 := []int{}
	n2 := []int{}
	r := []int{}
	for i := 0; i < len(nums); i++ {
		if nums[i] < 0 {
			n1 = append(n1, nums[i]*nums[i])
		} else {
			n2 = append(n2, nums[i]*nums[i])
		}
	}

	// n1 是负数平方，是倒序的
	for len(n1) > 0 && len(n2) > 0 {
		L := len(n1) - 1
		if n1[L] < n2[0] {
			r = append(r, n1[L])
			n1 = n1[:L]
		} else {
			r = append(r, n2[0])
			n2 = n2[1:]
		}
	}

	for i := len(n1) - 1; i >= 0; i-- {
		r = append(r, n1[i])
	}
	for i := 0; i < len(n2); i++ {
		r = append(r, n2[i])
	}
	return r
}

func main() {
	fmt.Println(sortedSquares([]int{-4, -1, 0, 3, 10}))
}
