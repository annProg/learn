package main

import "fmt"

func searchRange(nums []int, target int) []int {
	index := binarySearch(nums, target, 0, len(nums)-1)
	if index == -1 {
		return []int{-1, -1}
	}
	left, right := index, index
	for left > 0 {
		if nums[left-1] == target {
			left--
		} else {
			break
		}
	}
	for right < len(nums)-1 {
		if nums[right+1] == target {
			right++
		} else {
			break
		}
	}
	return []int{left, right}
}

func binarySearch(nums []int, target, start, end int) int {
	if start > end {
		return -1
	}
	mid := start + (end-start)/2
	if nums[mid] == target {
		return mid
	} else if nums[mid] > target {
		return binarySearch(nums, target, start, mid-1)
	} else {
		return binarySearch(nums, target, mid+1, end)
	}
}

func main() {
	fmt.Println(searchRange([]int{2, 2}, 2))
}
