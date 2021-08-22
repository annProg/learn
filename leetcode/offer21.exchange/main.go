package main

import "fmt"

func exchange(nums []int) []int {
	l, r := 0, len(nums)-1
	for l < r {
		if nums[l]%2 == 0 && nums[r]%2 != 0 {
			nums[l], nums[r] = nums[r], nums[l]
			l++
			r--
		}
		if nums[l]%2 != 0 {
			l++
		}
		if nums[r]%2 == 0 {
			r--
		}
	}
	return nums
}

func main() {
	fmt.Println(exchange([]int{1, 2, 3, 4}))
}
