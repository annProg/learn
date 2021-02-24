package main

import "fmt"

func Tribonacci(signature [3]float64, n int) []float64 {
	// your code here
	if n == 0 {
		return []float64{}
	}

	aRet := make([]float64, 0)
	for i := 0; i < n; i++ {
		if i < 3 {
			aRet = append(aRet, signature[i])
		} else {
			aRet = append(aRet, aRet[i-3]+aRet[i-2]+aRet[i-1])
		}
	}
	return aRet
}

func main() {
	fmt.Println(Tribonacci([3]float64{1, 1, 1}, 10))
}
