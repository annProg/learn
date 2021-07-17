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

// 动态规划
func maxSubArray2(nums []int) int {
	L := len(nums)
	if L < 2 {
		return nums[0]
	}
	max := nums[0]
	pre := max
	for i := 1; i < L; i++ {
		sum := nums[i]
		if nums[i]+pre > nums[i] {
			sum = nums[i] + pre
		}
		if sum > max {
			max = sum
		}
		pre = sum
	}
	return max
}

func main() {
	fmt.Println(maxSubArray([]int{-2, 1, -3, 4, -1, 2, 1, -5, 4}))
	fmt.Println(maxSubArray2([]int{-2, 1, -3, 4, -1, 2, 1, -5, 4}))
}
