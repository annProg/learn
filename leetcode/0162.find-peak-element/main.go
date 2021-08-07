package main

import "fmt"

func findPeakElement(nums []int) int {
	n := len(nums)
	return binFind(nums, 0, n-1)
}

func binFind(nums []int, start, end int) int {
	if start == end {
		return start
	}
	mid := start + (end-start)/2
	if nums[mid+1] > nums[mid] {
		return binFind(nums, mid+1, end)
	} else {
		return binFind(nums, start, mid)
	}
}

func main() {
	fmt.Println(findPeakElement([]int{1, 2, 3, 1, 2, 1}))
}
