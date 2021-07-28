package main

import "fmt"

func removeElement(nums []int, val int) int {
	L := len(nums)
	if L < 1 {
		return L
	}
	left, right := -1, 0
	for right < len(nums) {
		if nums[right] == val {
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
	nums := []int{3, 2, 2, 3}
	removeElement(nums, 3)
	fmt.Println(nums)
}
