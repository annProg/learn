package main

import "fmt"

func removeDuplicates(nums []int) int {
	L := len(nums)
	if L <= 1 {
		return L
	}
	left, right := 0, 1
	for right < len(nums) {
		if nums[right] == nums[right-1] {
			L--
		} else {
			left++
			nums[left] = nums[right]
		}
		right++
	}
	return L
}

func main() {
	nums := []int{1, 1, 1, 2, 3, 4, 4, 5}
	removeDuplicates(nums)
	fmt.Println(nums)
}
