package main

import "fmt"

func generate(numRows int) [][]int {
	r := make([][]int, numRows)
	for i := 0; i < numRows; i++ {
		r[i] = make([]int, i+1)
		for j := 0; j <= i; j++ {
			if i-1 < 0 || j == i || j-1 < 0 {
				r[i][j] = 1
			} else {
				r[i][j] = r[i-1][j-1] + r[i-1][j]
			}
		}
	}
	return r
}

func main() {
	fmt.Println(generate(5))
}
