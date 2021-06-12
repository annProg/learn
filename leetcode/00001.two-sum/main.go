package main

import "fmt"

func partition(nums []int, left, right int) int {
	pivot := left
	index := pivot
	for i := index + 1; i < right+1; i++ {
		if nums[i] < nums[pivot] {
			index += 1
			nums[i], nums[index] = nums[index], nums[i]
		}
	}
	nums[index], nums[pivot] = nums[pivot], nums[index]
	return index
}

func quick(nums []int, left, right int) {
	if left < right {
		partitionIndex := partition(nums, left, right)
		quick(nums, left, partitionIndex-1)
		quick(nums, partitionIndex+1, right)
	}
}

func binSearch(nums []int, target int, left, right int) int {
	if left > right {
		return -1
	}
	mid := int((right + left) / 2)
	if nums[mid] == target {
		return mid
	} else if nums[mid] > target {
		return binSearch(nums, target, left, mid-1)
	} else {
		return binSearch(nums, target, mid+1, right)
	}
}

func twoSum(nums []int, target int) []int {
	arr := make([]int, len(nums))
	copy(arr, nums)
	quick(arr, 0, len(nums)-1)
	for i := 0; i < len(nums); i++ {
		index := binSearch(arr, target-nums[i], 0, len(nums)-1)
		if index >= 0 {
			for j := 0; j < len(nums); j++ {
				if nums[j] == arr[index] && i != j {
					return []int{i, j}
				}
			}
		}
	}

	return []int{}
}

func twoSum2(nums []int, target int) []int {
	dict := make(map[int]int)
	var i int
	for i = 0; i < len(nums); i++ {
		dict[nums[i]] = i
	}
	for i = 0; i < len(nums); i++ {
		right := target - nums[i]
		if _, ok := dict[right]; ok {
			if i != dict[right] {
				return []int{i, dict[right]}
			}
		}
	}

	return []int{}
}

func twoSum3(nums []int, target int) []int {
	hashTable := map[int]int{}
	for i, x := range nums {
		if p, ok := hashTable[target-x]; ok {
			return []int{p, i}
		}
		hashTable[x] = i
	}
	return nil
}

func main() {
	nums := []int{3, 2, 4}
	// 此方法比直接遍历更费时
	fmt.Println(twoSum(nums, 5))
	// 此方法更快
	fmt.Println(twoSum2(nums, 5))
	fmt.Println(twoSum3(nums, 5))
}
