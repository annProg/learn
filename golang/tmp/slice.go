package main

import "fmt"

func main() {
	mySlice := make([]int, 5, 10)
	newSlice := mySlice[:6]
	fmt.Println("cap(mySlice):", cap(mySlice))
	fmt.Println("cap(newSlice):", cap(newSlice))
	fmt.Println("len(mySlice):", len(mySlice))
	fmt.Println("len(newSlice):", len(newSlice))
}
