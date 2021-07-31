package main

import "fmt"

func fib(n int) int {
	if n == 0 {
		return 0
	}
	if n == 1 {
		return 1
	}
	p2 := 0
	p1 := 1
	p := p2 + p1
	for i := 1; i < n; i++ {
		p = p2 + p1
		p2 = p1
		p1 = p
	}
	return p
}

func main() {
	fmt.Println(fib(5))
}
