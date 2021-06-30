package main

import "fmt"

// 双指针
func maxArea(height []int) int {
	max := 0
	left := 0
	right := len(height) - 1
	for left < right {
		small := height[left]
		if height[left] > height[right] {
			small = height[right]
		}
		area := small * (right - left)
		if area > max {
			max = area
		}
		if height[left] <= height[right] {
			left += 1
		} else {
			right -= 1
		}
	}
	return max
}
func main() {
	fmt.Println(maxArea([]int{1, 2, 3, 4, 5, 7, 8}))
	fmt.Println(maxArea([]int{1, 8, 6, 2, 5, 4, 8, 3, 7}))
}
