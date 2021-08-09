package main

import (
	"fmt"
	"sort"
)

func fourSum(nums []int, target int) [][]int {
	res := [][]int{}
	if len(nums) < 4 {
		return res
	}
	sort.Ints(nums)
	n := len(nums)

	for i := 0; i < n-3; i++ {
		if i > 0 && nums[i] == nums[i-1] {
			continue
		}
		for j := i + 1; j < n-2; j++ {
			if j > i+1 && nums[j] == nums[j-1] {
				continue
			}
			m := n - 1
			for k := j + 1; k < n-1; k++ {
				if k > j+1 && nums[k] == nums[k-1] {
					continue
				}
				// 需要保证 k 的指针在 m 的指针的左侧
				for k < m && nums[i]+nums[j]+nums[k]+nums[m] > target {
					m--
				}
				// 如果指针重合，随着 k 后续的增加
				// 就不会有满足条件的值了，可以退出循环
				if k == m {
					break
				}
				if nums[i]+nums[j]+nums[k]+nums[m] == target {
					res = append(res, []int{nums[i], nums[j], nums[k], nums[m]})
				}
			}
		}
	}
	return res
}

func main() {
	fmt.Println(fourSum([]int{1, 0, -1, 0, -2, 2}, 0))
}
