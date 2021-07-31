package main

import "fmt"

func isPowerOfTwo(n int) bool {
	if n != 1 && n%2 != 0 {
		return false
	}
	i := 0
	m := 0
	for m <= n {
		m = 1 << i
		if m == n {
			return true
		}
		i++
	}
	return false
}

// 官方题解
// 2的n次幂的二进制表示只有1个1
func isPowerOfTwo2(n int) bool {
	return n > 0 && n&(n-1) == 0
}

func main() {
	fmt.Println(isPowerOfTwo(17))
}
