package main

import (
	"fmt"
	"sort"
)

func threeSum2(nums []int) [][]int {
	sort.Ints(nums)
	n := len(nums)
	result := [][]int{}
	if n < 3 {
		return result
	}
	for i := 0; i < n-2; i++ {
		if i > 0 && nums[i] == nums[i-1] {
			continue
		}
		for j := i + 1; j < n-1; j++ {
			if j > i+1 && nums[j] == nums[j-1] {
				continue
			}
			target := -(nums[i] + nums[j])
			if search(nums, j+1, n-1, target) {
				result = append(result, []int{nums[i], nums[j], target})
			}
		}
	}
	return result
}

func search(nums []int, start, end, target int) bool {
	if start > end {
		return false
	}
	mid := start + (end-start)/2
	if nums[mid] == target {
		return true
	} else if nums[mid] < target {
		return search(nums, mid+1, end, target)
	} else {
		return search(nums, start, mid-1, target)
	}
}

// 题解
func threeSum(nums []int) [][]int {
	n := len(nums)
	sort.Ints(nums)
	ans := make([][]int, 0)

	// 枚举 a
	for first := 0; first < n; first++ {
		// 需要和上一次枚举的数不相同
		if first > 0 && nums[first] == nums[first-1] {
			continue
		}
		// c 对应的指针初始指向数组的最右端
		third := n - 1
		target := -1 * nums[first]
		// 枚举 b
		for second := first + 1; second < n; second++ {
			// 需要和上一次枚举的数不相同
			if second > first+1 && nums[second] == nums[second-1] {
				continue
			}
			// 需要保证 b 的指针在 c 的指针的左侧
			for second < third && nums[second]+nums[third] > target {
				third--
			}
			// 如果指针重合，随着 b 后续的增加
			// 就不会有满足 a+b+c=0 并且 b<c 的 c 了，可以退出循环
			if second == third {
				break
			}
			if nums[second]+nums[third] == target {
				ans = append(ans, []int{nums[first], nums[second], nums[third]})
			}
		}
	}
	return ans
}

func main() {
	fmt.Println(threeSum([]int{0, 0, 0, 0}))
}
