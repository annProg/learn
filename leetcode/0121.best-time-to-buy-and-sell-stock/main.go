package main

import "fmt"

// 当天的利润加上之前的利润
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

func maxProfit2(prices []int) int {
	minprice := 1 << 31
	maxprofit := 0
	for i := 0; i < len(prices); i++ {
		if prices[i] < minprice {
			minprice = prices[i]
		} else if prices[i]-minprice > maxprofit {
			maxprofit = prices[i] - minprice
		}
	}
	return maxprofit
}

func main() {
	fmt.Println(maxProfit([]int{7, 1, 5, 3, 6, 4}))
	fmt.Println(maxProfit2([]int{7, 1, 5, 3, 6, 4}))
}
