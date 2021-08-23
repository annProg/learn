package main

import (
	"fmt"
	"sort"
)

// nlogn
func longestConsecutive(nums []int) int {
	if len(nums) == 0 {
		return 0
	}
	sort.Ints(nums)
	m, max := 1, 1
	flag := 1

	for i := 1; i < len(nums); i++ {
		if nums[i]-1 != nums[i-1] && nums[i] != nums[i-1] {
			flag = 0
			m = 1
		} else if nums[i] == nums[i-1] {
			flag = 2
		} else {
			flag = 1
		}
		if flag == 1 {
			m++
		}
		if m > max {
			max = m
		}
	}
	return max
}

func main() {
	fmt.Println(longestConsecutive([]int{1, 2, 0, 1}))
}
