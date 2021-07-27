package main

import "fmt"

func maxAreaOfIsland(grid [][]int) int {
	max := 0

	r := len(grid)
	c := len(grid[0])
	for i := 0; i < r; i++ {
		for j := 0; j < c; j++ {
			if grid[i][j] == 1 {
				area := dfs(grid, r, c, i, j)
				if area > max {
					max = area
				}
			}
		}
	}
	return max
}

func dfs(grid [][]int, r, c, x, y int) int {
	area := 0
	if x >= 0 && y >= 0 && x < r && y < c && grid[x][y] == 1 {
		grid[x][y] = 2
		area += 1
		area += dfs(grid, r, c, x-1, y)
		area += dfs(grid, r, c, x+1, y)
		area += dfs(grid, r, c, x, y-1)
		area += dfs(grid, r, c, x, y+1)
	}
	return area
}

func main() {
	island := [][]int{{0, 0, 1, 1}, {1, 0, 1, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}}
	fmt.Println(maxAreaOfIsland(island))
}
