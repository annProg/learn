package main

import (
	"fmt"
	"sort"
)

// 三角形两边之和大于第三边  7%，太慢
func triangleNumber(nums []int) int {
	n := len(nums)
	if n < 3 {
		return 0
	}
	quicksort(nums, 0, n-1)
	count := 0
	for a := 0; a < n-2; a++ {
		for b := a + 1; b < n-1; b++ {
			for c := b + 1; c < n; c++ {
				if nums[a]+nums[b] > nums[c] {
					count++
				} else {
					break
				}
			}
		}
	}
	return count
}

func quicksort(nums []int, left, right int) {
	if left >= right {
		return
	}
	index := partition(nums, left, right)
	quicksort(nums, left, index-1)
	quicksort(nums, index+1, right)
}

func partition(nums []int, left, right int) int {
	pivot := left
	index := pivot
	for i := left + 1; i <= right; i++ {
		if nums[i] < nums[pivot] {
			index++
			nums[i], nums[index] = nums[index], nums[i]
		}
	}
	nums[pivot], nums[index] = nums[index], nums[pivot]
	return index
}

// 官方题解
func triangleNumber2(nums []int) (ans int) {
	n := len(nums)
	sort.Ints(nums)
	for i, v := range nums {
		k := i
		for j := i + 1; j < n; j++ {
			for k+1 < n && nums[k+1] < v+nums[j] {
				k++
			}
			ans += max(k-j, 0)
		}
	}
	return
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func main() {
	fmt.Println(triangleNumber([]int{2, 4, 3, 2, 5}))
}
