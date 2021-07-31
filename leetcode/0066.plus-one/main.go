package main

import "fmt"

func plusOne(digits []int) []int {
	L := len(digits)
	if digits[L-1] < 9 {
		digits[L-1] += 1
		return digits
	} else {
		flag := 1
		for i := L - 1; i >= 0; i-- {
			if digits[i] == 9 {
				digits[i] = 0
			} else {
				digits[i] += 1
				flag = 0
				break
			}
		}
		if flag == 1 {
			digits = append([]int{1}, digits...)
		}
	}
	return digits
}

func main() {
	fmt.Println(plusOne([]int{1, 9, 9}))
}
