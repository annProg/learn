package main

import "fmt"

func hanoi(n int, a, b, c string) {
	if n == 1 {
		move(a, c)
	} else {
		hanoi(n-1, a, c, b)
		move(a, c)
		hanoi(n-1, b, a, c)
	}
}

func move(source, target string) {
	fmt.Println(source, "->", target)
}

func main() {
	hanoi(20, "A", "B", "C")
}
