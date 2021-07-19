package main

import "fmt"

func matrixReshape(mat [][]int, r int, c int) [][]int {
	line := len(mat)
	column := len(mat[0])
	if line*column != r*c {
		return mat
	}

	n := make([][]int, r)

	for i := 0; i < r; i++ {
		n[i] = make([]int, c)
		for j := 0; j < c; j++ {
			count := i*c + j
			n[i][j] = mat[count/column][count%column]
		}
	}
	return n
}

func main() {
	fmt.Println(matrixReshape([][]int{{1, 2, 3, 4}}, 2, 2))
	fmt.Println(matrixReshape([][]int{{1, 2}, {3, 4}}, 4, 1))
}
