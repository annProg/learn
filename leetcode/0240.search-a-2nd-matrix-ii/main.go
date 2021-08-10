package main

import "fmt"

// 最坏情况下 O(n*m)
func findNumberIn2DArray2(matrix [][]int, target int) bool {
	row := len(matrix)
	if row == 0 {
		return false
	}
	col := len(matrix[0])
	if col == 0 {
		return false
	}
	r := getRow(matrix, 0, row-1, target)
	c := getCol(matrix, 0, col-1, target)
	for i := 0; i < r+1; i++ {
		for j := 0; j < c+1; j++ {
			if matrix[i][j] == target {
				return true
			}
		}
	}
	return false
}

func getRow(matrix [][]int, start, end, target int) int {
	if start > end {
		return start - 1
	}
	mid := start + (end-start)/2
	if matrix[mid][0] == target {
		return mid
	} else if matrix[mid][0] > target {
		return getRow(matrix, start, mid-1, target)
	} else {
		return getRow(matrix, mid+1, end, target)
	}
}

func getCol(matrix [][]int, start, end, target int) int {
	if start > end {
		return start - 1
	}
	mid := start + (end-start)/2
	if matrix[0][mid] == target {
		return mid
	} else if matrix[0][mid] > target {
		return getCol(matrix, start, mid-1, target)
	} else {
		return getCol(matrix, mid+1, end, target)
	}
}

// O(n+m)
func findNumberIn2DArray(matrix [][]int, target int) bool {
	row := len(matrix)
	if row == 0 {
		return false
	}
	col := len(matrix[0])
	if col == 0 {
		return false
	}

	r, c := 0, col-1
	for r < row && c >= 0 {
		if matrix[r][c] == target {
			return true
		} else if matrix[r][c] > target {
			c--
		} else {
			r++
		}
	}
	return false
}

func main() {
	fmt.Println(findNumberIn2DArray([][]int{{1, 1}}, 2))
}
