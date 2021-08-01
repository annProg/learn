package main

import (
	"fmt"
	"math"
)

func titleToNumber(columnTitle string) int {
	L := len(columnTitle)
	if L == 1 {
		return int(columnTitle[0]-'A') + 1
	}

	res := 0
	for i := 0; i < L; i++ {
		res = res + int(math.Pow(26, float64(L-1-i)))*(int(columnTitle[i]-'A')+1)
	}
	return res
}

// 官方题解
func titleToNumber2(columnTitle string) (number int) {
	for i, multiple := len(columnTitle)-1, 1; i >= 0; i-- {
		k := columnTitle[i] - 'A' + 1
		number += int(k) * multiple
		multiple *= 26
	}
	return
}

func main() {
	fmt.Println(titleToNumber("FXSHRXW"))
}
