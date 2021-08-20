package main

import "fmt"

func translateNum(num int) int {
	// f(n) = f(n-1) + f(n-2) or f(n-1)
	if num < 10 {
		return 1
	}
	nums := []int{}
	t := num
	for t > 0 {
		nums = append([]int{t % 10}, nums...)
		t = t / 10
	}

	f0, f1, f := 1, 1, 0
	for i := 1; i < len(nums); i++ {
		f = f1
		if nums[i-1]*10+nums[i] < 26 && nums[i-1] > 0 {
			f = f0 + f1
		}
		f0 = f1
		f1 = f
	}
	return f
}

func main() {
	fmt.Println(translateNum(12258))
}
