package main

import "fmt"

func intersect(nums1 []int, nums2 []int) []int {
	m := getMap(nums1)
	r := []int{}
	for i := 0; i < len(nums2); i++ {
		if _, ok := m[nums2[i]]; ok && m[nums2[i]] > 0 {
			r = append(r, nums2[i])
			m[nums2[i]] -= 1
		}
	}
	return r
}

func getMap(nums []int) map[int]int {
	m := map[int]int{}
	for i := 0; i < len(nums); i++ {
		if _, ok := m[nums[i]]; ok {
			m[nums[i]] += 1
		} else {
			m[nums[i]] = 1
		}
	}
	return m
}

// 题解
func intersect2(nums1 []int, nums2 []int) []int {
	if len(nums1) > len(nums2) {
		return intersect(nums2, nums1)
	}
	m := map[int]int{}
	for _, num := range nums1 {
		m[num]++
	}

	intersection := []int{}
	for _, num := range nums2 {
		if m[num] > 0 {
			intersection = append(intersection, num)
			m[num]--
		}
	}
	return intersection
}

func main() {
	fmt.Println(intersect([]int{4, 9, 5}, []int{9, 4, 9, 8, 4}))
}
