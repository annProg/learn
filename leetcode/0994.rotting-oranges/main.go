package main

import "fmt"

func orangesRotting(grid [][]int) int {
	row := len(grid)
	col := len(grid[0])
	que := [][]int{}

	fresh := 0

	for i := 0; i < row; i++ {
		for j := 0; j < col; j++ {
			if grid[i][j] == 2 {
				que = append(que, []int{i, j})
			}
			if grid[i][j] == 1 {
				fresh++
			}
		}
	}
	if fresh == 0 {
		return 0
	}
	stayFresh := fresh //被空格分隔的无法被腐烂
	minutes := -1
	direction := [][]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
	for len(que) > 0 {
		// 应使用层次遍历，一层里腐烂的会同时影响周围的新鲜橘子
		tmp := que
		que = nil
		for _, node := range tmp {
			x, y := node[0], node[1]
			// 上下左右搜索
			for _, dir := range direction {
				i, j := x+dir[0], y+dir[1]
				if i >= 0 && j >= 0 && i < row && j < col && grid[i][j] == 1 {
					grid[i][j] = -2
					que = append(que, []int{i, j})
					stayFresh--
				}
			}
		}
		minutes++
	}

	if stayFresh > 0 {
		return -1
	} else {
		return minutes
	}
}

func main() {
	grid := [][]int{{2, 1, 1}, {1, 1, 0}, {0, 1, 1}}
	fmt.Println(orangesRotting(grid))
}
