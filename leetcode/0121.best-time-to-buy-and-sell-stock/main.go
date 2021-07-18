package main

import "fmt"

func maxProfit(prices []int) int {
	max := 0
	pre := max
	for i := 1; i < len(prices); i++ {
		today := prices[i] - prices[i-1]
		if today+pre > max {
			max = pre + today
		}
		pre += today
		if pre < 0 {
			pre = 0
		}
	}
	return max
}

func main() {
	fmt.Println(maxProfit([]int{7, 1, 5, 3, 6, 4}))
}
