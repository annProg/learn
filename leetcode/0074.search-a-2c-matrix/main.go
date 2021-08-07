package main

import "fmt"

func searchMatrix(matrix [][]int, target int) bool {
	row := len(matrix)
	col := len(matrix[0])
	r := getRow(matrix, col, 0, row-1, target)
	if r == -1 {
		return false
	}
	return binSearch(matrix[r], 0, col-1, target)
}

func getRow(matrix [][]int, col, start, end, target int) int {
	if start > end {
		return -1
	}
	mid := start + (end-start)/2
	if target >= matrix[mid][0] && target <= matrix[mid][col-1] {
		return mid
	} else if target > matrix[mid][col-1] {
		return getRow(matrix, col, mid+1, end, target)
	} else {
		return getRow(matrix, col, start, mid-1, target)
	}
}

func binSearch(nums []int, start, end, target int) bool {
	if start > end {
		return false
	}
	mid := start + (end-start)/2
	if nums[mid] == target {
		return true
	} else if target < nums[mid] {
		return binSearch(nums, start, mid-1, target)
	} else {
		return binSearch(nums, mid+1, end, target)
	}
}

func main() {
	fmt.Println(searchMatrix([][]int{{1, 3, 5, 7}, {10, 11, 16, 20}, {23, 30, 34, 60}}, 3))
}
