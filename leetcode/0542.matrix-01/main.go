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

// 优化的BFS，从 0 开始搜索
func updateMatrix2(matrix [][]int) [][]int {

	n, m := len(matrix), len(matrix[0])
	queue := make([][]int, 0)
	for i := 0; i < n; i++ { // 把0全部存进队列，后面从队列中取出来，判断每个访问过的节点的上下左右，直到所有的节点都被访问过为止。
		for j := 0; j < m; j++ {
			if matrix[i][j] == 0 {
				point := []int{i, j}
				queue = append(queue, point)
			} else {
				matrix[i][j] = -1
			}
		}
	}
	direction := [][]int{{0, 1}, {0, -1}, {1, 0}, {-1, 0}}

	for len(queue) > 0 { // 这里就是 BFS 模板操作了。
		point := queue[0]
		queue = queue[1:]
		for _, v := range direction {
			x := point[0] + v[0]
			y := point[1] + v[1]
			if x >= 0 && x < n && y >= 0 && y < m && matrix[x][y] == -1 {
				matrix[x][y] = matrix[point[0]][point[1]] + 1
				queue = append(queue, []int{x, y})
			}
		}
	}

	return matrix
}

func main() {
	mat := [][]int{{1, 1, 1, 1}, {1, 1, 1, 1}, {1, 1, 1, 1}, {1, 0, 0, 0}}
	ret := updateMatrix(mat)
	fmt.Println(ret)
}
