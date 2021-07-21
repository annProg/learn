package main

import "fmt"

func setZeroes(matrix [][]int) {
	line := map[int]int{}
	column := map[int]int{}
	for i := 0; i < len(matrix); i++ {
		for j := 0; j < len(matrix[i]); j++ {
			if matrix[i][j] == 0 {
				line[i] = 1
				column[j] = 1
			}
		}
	}

	for i := 0; i < len(matrix); i++ {
		for j := 0; j < len(matrix[i]); j++ {
			if _, ok := line[i]; ok {
				matrix[i][j] = 0
			}
			if _, ok := column[j]; ok {
				matrix[i][j] = 0
			}
		}
	}
}

// 标记数组 空间复杂度 O(m+n)
func setZeroes2(matrix [][]int) {
	row := make([]bool, len(matrix))
	col := make([]bool, len(matrix[0]))
	for i, r := range matrix {
		for j, v := range r {
			if v == 0 {
				row[i] = true
				col[j] = true
			}
		}
	}
	for i, r := range matrix {
		for j := range r {
			if row[i] || col[j] {
				r[j] = 0
			}
		}
	}
}

func main() {
	matrix := [][]int{{1, 1, 1}, {1, 0, 1}, {1, 1, 1}}
	setZeroes(matrix)
	fmt.Println(matrix)
}
