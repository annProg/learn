package main

import (
	"leetcode/libs/tree"
)

type TreeNode = tree.TreeNode

func sortedArrayToBST(nums []int) *TreeNode {
	L := len(nums)
	if L == 0 {
		return nil
	}
	mid := L / 2
	root := &TreeNode{Val: nums[mid]}
	root.Left = sortedArrayToBST(nums[0:mid])
	root.Right = sortedArrayToBST(nums[mid+1:])
	return root
}

func main() {
	root := sortedArrayToBST([]int{-10, -8, -5, 0, 2, 5, 9})
	root.Print()
}
