package main

import "fmt"

func containsDuplicate(nums []int) bool {
	m := map[int]int{}

	for _, v := range nums {
		if _, ok := m[v]; ok {
			return true
		} else {
			m[v] = 1
		}
	}
	return false
}

func main() {
	fmt.Println(containsDuplicate([]int{1, 2, 3, 1}))
}
