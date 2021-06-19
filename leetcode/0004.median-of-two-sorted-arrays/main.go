package main

import "fmt"

func findMedianSortedArrays(nums1 []int, nums2 []int) float64 {
	nums := merge(nums1, nums2)
	return getMedian(nums)
}

func merge(left []int, right []int) []int {
	result := []int{}
	for len(left) > 0 && len(right) > 0 {
		if left[0] <= right[0] {
			result = append(result, left[0])
			left = left[1:]
		} else {
			result = append(result, right[0])
			right = right[1:]
		}
	}
	if len(left) > 0 {
		result = append(result, left...)
	}
	if len(right) > 0 {
		result = append(result, right...)
	}
	return result
}

func getMedian(nums []int) float64 {
	l := len(nums)
	if l == 0 {
		return -1.0
	}
	if l%2 == 0 {
		return float64(nums[l/2-1]+nums[l/2]) / 2
	} else {
		return float64(nums[(l-1)/2])
	}
}

func main() {
	fmt.Println(findMedianSortedArrays([]int{1, 3}, []int{2, 7}))
	fmt.Println(findMedianSortedArrays([]int{1}, []int{2, 3, 4}))
}
