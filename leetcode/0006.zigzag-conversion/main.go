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
	result := make([]string, numRows)

	index := 0
	for j := 0; index < L; j++ {
		for i := 0; i < numRows && index < L; i++ {
			result[i] += string(s[index])
			index += 1
		}
		j += 1
		for k := numRows - 2; k > 0 && index < L; k-- {
			result[k] += string(s[index])
			index += 1
		}
	}

	return strings.Join(result, "")
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
	fmt.Println(convert("ABCDE", 2))
	fmt.Println(convert2("PAYPALISHIRING", 3))
}
