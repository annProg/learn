package main

import "fmt"

func findMin(nums []int) int {
	n := len(nums)
	pos := 0
	if nums[0] > nums[n-1] {
		pos = find(nums, 0, n-1)
	}
	return nums[pos]
}

func find(nums []int, start, end int) int {
	if start > end {
		return start
	}
	mid := start + (end-start)/2
	if nums[mid] < nums[0] {
		return find(nums, start, mid-1)
	} else {
		return find(nums, mid+1, end)
	}
}

func main() {
	fmt.Println(findMin([]int{3, 4, 5, 1, 2}))
}
