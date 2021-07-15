package main

import "fmt"

func quicksort(nums []int, start, end int) {
	if start >= end {
		return
	}

	index := partition(nums, start, end)
	quicksort(nums, start, index-1)
	quicksort(nums, index+1, end)
}

func partition(nums []int, start, end int) int {
	pivot := start
	index := pivot

	for i := start + 1; i <= end; i++ {
		if nums[i] < nums[pivot] {
			index += 1
			nums[index], nums[i] = nums[i], nums[index]
		}
	}
	nums[index], nums[pivot] = nums[pivot], nums[index]
	return index
}

func mergesort(nums []int) []int {
	if len(nums) < 2 {
		return nums
	}
	mid := len(nums) / 2
	left, right := nums[0:mid], nums[mid:]
	return merge(mergesort(left), mergesort(right))
}

func merge(left, right []int) []int {
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
	for len(left) > 0 {
		result = append(result, left[0])
		left = left[1:]
	}

	for len(right) > 0 {
		result = append(result, right[0])
		right = right[1:]
	}
	return result
}

func main() {
	arr := []int{5, 4, 6, 3, 1, 2}
	quicksort(arr, 0, len(arr)-1)
	fmt.Println(arr)
	arr2 := []int{5, 4, 6, 3, 1, 2, 10, 0, 5, 4}
	fmt.Println(mergesort(arr2))
}
