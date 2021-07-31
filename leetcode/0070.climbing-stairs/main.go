package main

import "fmt"

// 超时
func climbStairs2(n int) int {
	if n == 1 {
		return 1
	}
	if n == 2 {
		return 2
	}
	return climbStairs2(n-1) + climbStairs2(n-2)
}

// 动态规划
func climbStairs(n int) int {
	if n == 1 {
		return 1
	}
	var dp []int
	if n > 1 {
		dp = make([]int, n)
		dp[0] = 1
		dp[1] = 2
	}
	for i := 2; i < n; i++ {
		dp[i] = dp[i-1] + dp[i-2]
	}
	return dp[n-1]
}

// 官方题解
func climbStairs3(n int) int {
	p, q, r := 0, 0, 1
	for i := 1; i <= n; i++ {
		p = q
		q = r
		r = p + q
	}
	return r
}

func main() {
	fmt.Println(climbStairs(6))
}
