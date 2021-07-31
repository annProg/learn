package main

import "fmt"

func tribonacci(n int) int {
	if n < 2 {
		return n
	}
	if n == 2 {
		return 1
	}
	p3, p2, p1, r := 0, 1, 1, 0
	for i := 3; i <= n; i++ {
		r = p3 + p2 + p1
		p3 = p2
		p2 = p1
		p1 = r
	}
	return r
}

func main() {
	fmt.Println(tribonacci(5))
}
