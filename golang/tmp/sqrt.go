package main

import (
	"fmt"
	"math"
	"time"
)

func Sqrt(x float64) float64 {
	z := 1.0
	for i := 0; i < 10; i++ {
		z = z - (z*z-x)/(2*z)
	}
	return z
}

func main() {
	t1 := time.Now()
	fmt.Println(Sqrt(7000))
	t2 := time.Now()
	fmt.Println(math.Sqrt(7000))
	t3 := time.Now()

	fmt.Println(t2.Sub(t1))
	fmt.Println(t3.Sub(t2))
}
