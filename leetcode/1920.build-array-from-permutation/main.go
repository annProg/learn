package main

import "fmt"

func buildArray(nums []int) []int {
	L := len(nums)
	r := make([]int, L)
	for i := 0; i < L; i++ {
		r[i] = nums[nums[i]]
	}
	return r
}

// 原地修改
// nums 值范围0-999，因此，我们可以使用类似「1000 进制」的思路来表示每个元素的「当前值」和「最终值」。
//对于每个元素，我们用它除以 1000 的商数表示它的「最终值」，而用余数表示它的「当前值」。
// 例如 1002%1000 = 2 是当前值， 1002/1000 = 1 是最终值
func buildArray2(nums []int) []int {
	L := len(nums)
	for i := 0; i < L; i++ {
		nums[i] += 1000 * (nums[nums[i]] % 1000)
	}
	for i := 0; i < L; i++ {
		nums[i] /= 1000
	}
	return nums
}

func main() {
	fmt.Println(buildArray([]int{0, 2, 1, 5, 3, 4}))
	fmt.Println(buildArray2([]int{0, 2, 1, 5, 3, 4}))
}
