package main

import "fmt"

func isValidSudoku(board [][]byte) bool {
	// 分别存储行，列， 3x3宫 内数字出现的情况
	line := make([]map[byte]int, 9)
	column := make([]map[byte]int, 9)
	block := make([]map[byte]int, 9)
	for i := 0; i < 9; i++ {
		line[i] = make(map[byte]int)
		column[i] = make(map[byte]int)
		block[i] = make(map[byte]int)
	}

	for i := 0; i < len(board); i++ {
		for j := 0; j < len(board[i]); j++ {
			ch := board[i][j]
			// 算 3x3 宫是第几个
			bi := i/3*3 + j/3
			if ch == '.' {
				continue
			} else {
				line[i][ch] += 1
				column[j][ch] += 1
				block[bi][ch] += 1

				if line[i][ch] > 1 || column[j][ch] > 1 || block[bi][ch] > 1 {
					return false
				}
			}
		}
	}
	return true
}

func main() {
	sudoku := [][]byte{{'5', '3', '.', '.', '7', '.', '.', '.', '.'}, {'6', '.', '.', '1', '9', '5', '.', '.', '.'}, {'.', '9', '8', '.', '.', '.', '.', '6', '.'}, {'8', '.', '.', '.', '6', '.', '.', '.', '3'}, {'4', '.', '.', '8', '.', '3', '.', '.', '1'}, {'7', '.', '.', '.', '2', '.', '.', '.', '6'}, {'.', '6', '.', '.', '.', '.', '2', '8', '.'}, {'.', '.', '.', '4', '1', '9', '.', '.', '5'}, {'.', '.', '.', '.', '8', '.', '.', '7', '9'}}
	fmt.Println(isValidSudoku(sudoku))
}
