package main

import "fmt"

func moveZeroes(nums []int) {
	i := 0
	j := 0
	L := len(nums)
	for i < L && j < L {
		if nums[j] != 0 && nums[i] == 0 {
			nums[i], nums[j] = nums[j], nums[i]
		}

		if nums[i] != 0 {
			i++
		}
		j++
	}
}

// 官方题解
func moveZeroes2(nums []int) {
	left, right, n := 0, 0, len(nums)
	for right < n {
		if nums[right] != 0 {
			nums[left], nums[right] = nums[right], nums[left]
			left++
		}
		right++
	}
}

func main() {
	nums := []int{0, 1, 0, 3, 12}
	moveZeroes(nums)
	fmt.Println(nums)
}
