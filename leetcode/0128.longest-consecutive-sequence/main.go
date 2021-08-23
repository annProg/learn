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

func longestConsecutive2(nums []int) int {
	m := map[int]int{}

	max := 0
	for _, v := range nums {
		if dictGet(m, v) == 0 {
			left := dictGet(m, v-1)
			right := dictGet(m, v+1)

			cur := 1 + left + right

			if cur > max {
				max = cur
			}
			m[v] = cur
			m[v-left] = cur
			m[v+right] = cur
		}
	}
	return max
}

func dictGet(m map[int]int, v int) int {
	if _, ok := m[v]; ok {
		return m[v]
	}
	return 0
}

func main() {
	fmt.Println(longestConsecutive2([]int{1, 2, 0, 1}))
}
