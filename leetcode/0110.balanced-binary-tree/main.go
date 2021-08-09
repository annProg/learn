package main

import (
	"fmt"
	"leetcode/libs/tree"
)

type TreeNode = tree.TreeNode

func isBalanced2(root *TreeNode) bool {
	if root == nil {
		return true
	}
	left := MaxDepth(root.Left)
	right := MaxDepth(root.Right)
	if left-right > 1 || right-left > 1 {
		return false
	}
	return isBalanced2(root.Left) && isBalanced2(root.Right)
}

func MaxDepth(root *TreeNode) int {
	depth := 0
	if root == nil {
		return depth
	}
	depth += 1
	left := depth + MaxDepth(root.Left)
	right := depth + MaxDepth(root.Right)
	if left >= right {
		return left
	}
	return right
}

// 官方题解
func isBalanced(root *TreeNode) bool {
	return height(root) >= 0
}

func height(root *TreeNode) int {
	if root == nil {
		return 0
	}
	leftHeight := height(root.Left)
	rightHeight := height(root.Right)
	if leftHeight == -1 || rightHeight == -1 || abs(leftHeight-rightHeight) > 1 {
		return -1
	}
	return max(leftHeight, rightHeight) + 1
}

func max(x, y int) int {
	if x > y {
		return x
	}
	return y
}

func abs(x int) int {
	if x < 0 {
		return -1 * x
	}
	return x
}

func main() {
	nodes := []interface{}{1, 2, 2, 3, nil, nil, 3, 4, nil, nil, 4}
	tree := new(TreeNode)
	tree.Init(nodes)
	fmt.Println(isBalanced(tree))
}
