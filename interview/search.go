// 5,6,7,7,9,1,2,2,3  为前后两部分有序的序列，后半部分都比前半部分小，分割点未知
// 找出 8 和 2 第一次出现的位置

// 和 leetcode 81 几乎一样

package main

import (
	"fmt"
)

func indexSearch(nums []int, L, start, end int) int {
	if start+1 >= end {
		return start
	}
	mid := start + (end-start)/2
	if nums[mid] >= nums[L-1] {
		return indexSearch(nums, L, mid, end)
	} else {
		return indexSearch(nums, L, start, mid)
	}
}

func binarySearch(nums []int, target, start, end int) int {
	if start > end {
		return -1
	}
	if start == end {
		if nums[start] != target {
			return -1
		}
		return start
	}
	mid := start + (end-start)/2
	if target <= nums[mid] {
		return binarySearch(nums, target, start, mid)
	} else {
		return binarySearch(nums, target, mid+1, end)
	}
}

func find(nums []int, target int) int {
	index := indexSearch(nums, len(nums), 0, len(nums)-1)
	fmt.Println(index)
	if target >= nums[0] && target <= nums[index] {
		return binarySearch(nums, target, 0, index)
	} else {
		return binarySearch(nums, target, index+1, len(nums)-1)
	}
}

func main() {
	nums := []int{5, 6, 7, 7, 9, 1, 2, 2, 3}
	//nums := []int{5}
	//nums := []int{1, 1, 1, 1, 1, 1, 2, 1, 1, 1}
	fmt.Println(find(nums, 8))
	fmt.Println(find(nums, 2))
}
