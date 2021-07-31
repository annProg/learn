package main

import "fmt"

func rob(nums []int) int {
	L := len(nums)
	if L == 0 {
		return 0
	}
	if L == 1 {
		return nums[0]
	}
	if L == 2 {
		return max(nums[0], nums[1])
	}
	p2 := nums[0]
	p1 := max(nums[0], nums[1])
	m := max(p2, p1)
	for i := 2; i < L; i++ {
		p := max(p2+nums[i], p1)
		if p > m {
			m = p
		}
		p2 = p1
		p1 = p
	}
	return m
}

func max(a, b int) int {
	if a >= b {
		return a
	}
	return b
}

func main() {
	fmt.Println(rob([]int{2, 1, 1, 2}))
}
