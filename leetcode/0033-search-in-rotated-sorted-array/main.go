package main

import "fmt"

func search(nums []int, target int) int {
	n := len(nums)
	pos := 0
	if nums[0] > nums[n-1] {
		pos = find(nums, 0, n-1)
	}
	if pos == 0 {
		return binSearch(nums, 0, n-1, target)
	} else {
		if target < nums[pos] || target > nums[pos-1] {
			return -1
		} else if target >= nums[0] && target <= nums[pos-1] {
			return binSearch(nums, 0, pos-1, target)
		} else {
			return binSearch(nums, pos, n-1, target)
		}
	}
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

func binSearch(nums []int, start, end, target int) int {
	if start > end {
		return -1
	}
	mid := start + (end-start)/2
	if nums[mid] == target {
		return mid
	} else if target < nums[mid] {
		return binSearch(nums, start, mid-1, target)
	} else {
		return binSearch(nums, mid+1, end, target)
	}
}

// 题解
func search2(nums []int, target int) int {
	n := len(nums)
	if n == 1 {
		if ok := nums[0] == target; ok {
			return 0
		}
		return -1
	}
	left, right := 0, n-1
	for left <= right {
		mid := left + (right-left)/2
		if nums[mid] == target {
			return mid
		}
		if nums[0] <= nums[mid] {
			if nums[0] <= target && target < nums[mid] {
				right = mid - 1
			} else {
				left = mid + 1
			}
		} else {
			if nums[mid] < target && target <= nums[n-1] {
				left = mid + 1
			} else {
				right = mid - 1
			}
		}
	}
	return -1
}

func main() {
	fmt.Println(search2([]int{2, 3, 1}, 1))
}
