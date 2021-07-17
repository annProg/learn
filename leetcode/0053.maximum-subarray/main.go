package main

import "fmt"

// 暴力法
func maxSubArray(nums []int) int {
	L := len(nums)
	if L < 2 {
		return nums[0]
	}
	max := nums[0]
	for i := 0; i < L; i++ {
		sum := 0
		for j := i; j < L; j++ {
			sum += nums[j]
			if sum > max {
				max = sum
			}
		}
	}
	return max
}

func main() {
	fmt.Println(maxSubArray([]int{-2, 1, -3, 4, -1, 2, 1, -5, 4}))
}
