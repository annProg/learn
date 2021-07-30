package main

import (
	"fmt"
	"leetcode/libs/tree"
)

type TreeNode = tree.TreeNode

func isValidBST(root *TreeNode) bool {
	return valid(root, -1*1<<32, 1<<32)
}

func valid(root *TreeNode, lower, upper int) bool {
	if root == nil {
		return true
	}
	if root.Val <= lower || root.Val >= upper {
		return false
	}
	return valid(root.Left, lower, root.Val) && valid(root.Right, root.Val, upper)
}

func main() {
	nodes := []interface{}{5, 4, 6, nil, nil, 3, 7}
	tree := &TreeNode{}
	tree.Init(nodes)
	fmt.Println(isValidBST(tree))
}
