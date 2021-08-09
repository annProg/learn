package main

import (
	"fmt"
	"math/big"
)

// f(m,n) = f(m-1,n) + f(m,n-1)
func uniquePaths(m int, n int) int {
	dp := make([][]int, m)
	for i := 0; i < m; i++ {
		dp[i] = make([]int, n)
		for j := 0; j < n; j++ {
			if i == 0 || j == 0 {
				dp[i][j] = 1
			} else {
				dp[i][j] = dp[i-1][j] + dp[i][j-1]
			}
		}
	}
	return dp[m-1][n-1]
}

// 排列组合 C(m+n-2, m-1) = (m+n-2)!/((m-1)!*(n-1)!) = (m+n-2)*...n/(m-1)!
func uniquePaths2(m, n int) int {
	return int(new(big.Int).Binomial(int64(m+n-2), int64(n-1)).Int64())
}

func main() {
	fmt.Println(uniquePaths2(59, 5))
}
