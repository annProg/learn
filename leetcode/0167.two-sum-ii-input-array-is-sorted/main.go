package main

import "fmt"

func twoSum(numbers []int, target int) []int {
	r := make([]int, 2)
	left := 0
	right := len(numbers) - 1
	for left < right {
		sum := numbers[left] + numbers[right]
		if sum > target {
			right--
		} else if sum < target {
			left++
		} else {
			r = []int{left + 1, right + 1}
			break
		}
	}
	return r
}

func main() {
	fmt.Println(twoSum([]int{2, 7, 11, 15}, 9))
}
