package main

import "fmt"

func fizzBuzz(n int) []string {
	res := make([]string, n)
	for i := 1; i <= n; i++ {
		n3, n5 := i%3, i%5
		if n3 == 0 && n5 == 0 {
			res[i-1] = "FizzBuzz"
		} else if n3 == 0 {
			res[i-1] = "Fizz"
		} else if n5 == 0 {
			res[i-1] = "Buzz"
		} else {
			res[i-1] = fmt.Sprint(i)
		}
	}
	return res
}

func main() {
	fmt.Println(fizzBuzz(3))
}
