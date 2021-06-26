package main

import (
	"fmt"
	"strings"
)

func convert(s string, numRows int) string {
	if numRows == 1 {
		return s
	}
	L := len(s)
	result := make([][]byte, numRows)
	for i := range result {
		result[i] = make([]byte, L)
	}

	index := 0
	for j := 0; index < L; j++ {
		for i := 0; i < numRows && index < L; i++ {
			result[i][j] = s[index]
			index += 1
		}
		j += 1
		for k := numRows - 2; k > 0 && index < L; k-- {
			result[k][j] = s[index]
			index += 1
		}
	}

	r := ""
	for i := range result {
		for j := range result[i] {
			if result[i][j] != 0 {
				r += string(result[i][j])
			}
		}
	}

	return r
}

func convert2(s string, numRows int) string {
	if numRows == 1 {
		return s
	}

	result := make([]string, numRows)

	j, flag := 0, -1
	for i := 0; i < len(s); i++ {
		result[j] += string(s[i])
		if j == 0 || j == numRows-1 {
			flag = -flag
		}
		j += flag
	}
	return strings.Join(result, "")
}

func main() {
	fmt.Println(convert2("ABCDE", 2))
	fmt.Println(convert2("PAYPALISHIRING", 3))
}
