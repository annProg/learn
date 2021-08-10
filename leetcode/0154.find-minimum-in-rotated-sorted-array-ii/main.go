package main

import "fmt"

func findMin(nums []int) int {
	low := 0
	high := len(nums) - 1
	for low < high {
		pivot := low + (high-low)/2
		if nums[pivot] < nums[high] {
			high = pivot
		} else if nums[pivot] > nums[high] {
			low = pivot + 1
		} else {
			high--
		}
	}
	return nums[low]
}

func main() {
	fmt.Println(findMin([]int{2, 2, 2, 0, 1}))
}
