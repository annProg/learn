package main

import "fmt"

/*
交换律：a ^ b ^ c <=> a ^ c ^ b
任何数于0异或为任何数 0 ^ n => n
相同的数异或为0: n ^ n => 0
var a = [2,3,2,4,4]
2 ^ 3 ^ 2 ^ 4 ^ 4等价于 2 ^ 2 ^ 4 ^ 4 ^ 3 => 0 ^ 0 ^3 => 3
*/
func singleNumber(nums []int) int {
	res := 0
	for i := 0; i < len(nums); i++ {
		res = res ^ nums[i]
	}
	return res
}

func main() {
	fmt.Println(singleNumber([]int{2, 2, 3, 3, 4, 4, 5}))
}
