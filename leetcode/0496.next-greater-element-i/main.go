package main

import "fmt"

// 暴力
func nextGreaterElement(nums1 []int, nums2 []int) []int {
	m := map[int]int{}

	for i, v := range nums2 {
		m[v] = i
	}

	res := []int{}
	for _, v := range nums1 {
		flag := -1
		for i := m[v] + 1; i < len(nums2); i++ {
			if nums2[i] > v {
				flag = nums2[i]
				break
			}
		}
		res = append(res, flag)
	}
	return res
}

// 单调栈
func nextGreaterElement2(nums1 []int, nums2 []int) []int {
	stack := []int{}
	m := map[int]int{}
	for _, v := range nums2 {
		for len(stack) > 0 && v > stack[len(stack)-1] {
			m[stack[len(stack)-1]] = v
			stack = stack[0 : len(stack)-1]
		}
		stack = append(stack, v)
	}

	res := []int{}
	for _, v := range nums1 {
		if _, ok := m[v]; ok {
			res = append(res, m[v])
		} else {
			res = append(res, -1)
		}
	}
	return res
}

func main() {
	fmt.Println(nextGreaterElement([]int{4, 1, 2}, []int{1, 3, 4, 2}))
	fmt.Println(nextGreaterElement2([]int{1, 3, 5, 2, 4}, []int{6, 5, 4, 3, 2, 1, 7}))
}
