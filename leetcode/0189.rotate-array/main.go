package main

import "fmt"

func rotate(nums []int, k int) {
	L := len(nums)
	k = k % L
	n1 := nums[L-k:]
	n2 := nums[:L-k]
	n1 = append(n1, n2...)
	copy(nums, n1)
}

// 空间复杂度 O(1)
func rotate2(nums []int, k int) {
	k %= len(nums)
	reverse(nums)
	reverse(nums[:k])
	reverse(nums[k:])
}

func reverse(a []int) {
	for i, n := 0, len(a); i < n/2; i++ {
		a[i], a[n-1-i] = a[n-1-i], a[i]
	}
}

func main() {
	nums := []int{1, 2, 3, 4, 5, 6, 7}
	rotate(nums, 3)
	fmt.Println(nums)
}
