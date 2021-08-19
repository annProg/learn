package main

import "fmt"

func maxValue(grid [][]int) int {
	// fn = max(left+n, up+n)
	row := len(grid)
	if row == 0 {
		return 0
	}
	col := len(grid[0])
	if row == 1 && col == 1 {
		return grid[0][0]
	}

	dp := make([][]int, row)
	for i := 0; i < row; i++ {
		dp[i] = make([]int, col)
	}
	dp[0][0] = grid[0][0]
	// 初始化第一行
	for j := 1; j < col; j++ {
		dp[0][j] = dp[0][j-1] + grid[0][j]
	}
	// 初始化第一列
	for i := 1; i < row; i++ {
		dp[i][0] = dp[i-1][0] + grid[i][0]
	}

	for i := 1; i < row; i++ {
		for j := 1; j < col; j++ {
			dp[i][j] = max(dp[i][j-1]+grid[i][j], dp[i-1][j]+grid[i][j])
		}
	}
	return dp[row-1][col-1]
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func main() {
	fmt.Println(maxValue([][]int{{1, 3, 1}, {1, 5, 1}, {4, 2, 1}}))
}
