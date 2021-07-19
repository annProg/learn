package main

import "fmt"

func search(nums []int, target int) int {
	return binSearch(nums, target, 0, len(nums)-1)
}

func binSearch(nums []int, target, left, right int) int {
	if left > right {
		return -1
	}
	mid := (left + right) / 2
	if nums[mid] > target {
		return binSearch(nums, target, left, mid-1)
	} else if nums[mid] < target {
		return binSearch(nums, target, mid+1, right)
	} else {
		return mid
	}
}

func main() {
	fmt.Println(search([]int{-1, 0, 3, 5, 9, 12}, 9))
}
