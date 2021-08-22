package main

import "fmt"

func twoSum(nums []int, target int) []int {
	res := make([]int, 2)
	l, r := 0, len(nums)-1
	for l < r {
		sum := nums[l] + nums[r]
		if sum == target {
			res[0] = nums[l]
			res[1] = nums[r]
			break
		} else if sum > target {
			r--
		} else {
			l++
		}

	}
	return res
}

func main() {
	fmt.Println(twoSum([]int{2, 7, 11, 15}, 9))
}
