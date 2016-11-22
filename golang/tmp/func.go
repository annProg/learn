package main

import "fmt"

func example(x int) int {
	if x == 0 {
		return 5
	} else {
		return x
	}
}

func main() {
	fmt.Println(example(6))
	fmt.Println(example(0))
}
