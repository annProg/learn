package main

import (
	"fmt"
	"strconv"
	"strings"
)

func Smallest(n int64) []int64 {
	numStr := strconv.FormatInt(n, 10)

	var min int64 = n
	var from int64 = 0
	var to int64 = 0
	for i := 0; i < len(numStr); i++ {
		for j := 0; j < len(numStr); j++ {
			arr := strings.Split(numStr, "")
			pick := arr[i]
			arr[i] = ""
			if i > j {
				arr[j] = pick + arr[j]
			} else {
				arr[j] = arr[j] + pick
			}
			newStr := strings.Join(arr, "")
			newInt, _ := strconv.ParseInt(newStr, 10, 64)
			if newInt < min {
				min = newInt
				from = int64(i)
				to = int64(j)
			}
		}
	}
	return []int64{min, from, to}
}

func main() {
	fmt.Println(Smallest(261235))
	fmt.Println(Smallest(209999))
}
