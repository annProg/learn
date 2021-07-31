package main

import "fmt"

// 太慢 只超过5%
func hammingWeight2(num uint32) int {
	sum := 0
	for i := 0; i < 32; i++ {
		if num%2 == 1 {
			sum++
		}
		num = num >> 1
	}
	return sum
}

// num % 2 改成 num & 1 之后超过 100%
func hammingWeight(num uint32) int {
	sum := 0
	for i := 0; i < 32; i++ {
		if num&1 == 1 {
			sum++
		}
		num = num >> 1
	}
	return sum
}

// 官方题解，更加简洁
func hammingWeight3(num uint32) (ones int) {
	for i := 0; i < 32; i++ {
		if 1<<i&num > 0 {
			ones++
		}
	}
	return
}

// 官方题解2 优化 n & (n-1) ，按位与运算能消除n最后一位1，这样循环次数只有1的数量
func hammingWeight4(num uint32) (ones int) {
	for ; num > 0; num &= num - 1 {
		ones++
	}
	return
}

func main() {
	fmt.Println(hammingWeight2(13))
}
