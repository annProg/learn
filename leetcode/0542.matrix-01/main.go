package main

import (
	"fmt"
)

func updateMatrix(mat [][]int) [][]int {
	row := len(mat)
	col := len(mat[0])
	ret := make([][]int, row)

	for i := 0; i < row; i++ {
		ret[i] = make([]int, col)
		for j := 0; j < col; j++ {
			if mat[i][j] == 0 {
				ret[i][j] = 0
			} else {
				ret[i][j] = bfs(mat, row, col, i, j)
			}
		}
	}
	return ret
}

func bfs(mat [][]int, row, col, i, j int) int {
	que := [][]int{}
	que = append(que, []int{i, j})

	color := 10*i + 3*j + 2
	mat[i][j] = color

	min := 1
	for len(que) > 0 {
		// 层次遍历，一次性遍历所有相邻的坐标，然后在读入下一层相邻坐标
		tmp := que
		que = nil
		for _, node := range tmp {
			x, y := node[0], node[1]
			if (x-1 >= 0 && mat[x-1][y] == 0) || (x+1 < row && mat[x+1][y] == 0) || (y-1 >= 0 && mat[x][y-1] == 0) || (y+1 < col && mat[x][y+1] == 0) {
				return min
			} else {
				if x-1 >= 0 && mat[x-1][y] != color {
					que = append(que, []int{x - 1, y})
					mat[x-1][y] = color
				}
				if x+1 < row && mat[x+1][y] != color {
					que = append(que, []int{x + 1, y})
					mat[x+1][y] = color
				}
				if y-1 >= 0 && mat[x][y-1] != color {
					que = append(que, []int{x, y - 1})
					mat[x][y-1] = color
				}
				if y+1 < col && mat[x][y+1] != color {
					que = append(que, []int{x, y + 1})
					mat[x][y+1] = color
				}
			}
		}
		// 处理完相邻之后如果没有结束，才需要加1
		min += 1
	}
	return min
}

func main() {
	mat := [][]int{{1, 1, 1, 1}, {1, 1, 1, 1}, {1, 1, 1, 1}, {1, 0, 0, 0}}
	ret := updateMatrix(mat)
	fmt.Println(ret)
}
