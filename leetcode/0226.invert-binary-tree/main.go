package main

import (
	"leetcode/libs/tree"
)

type TreeNode = tree.TreeNode

func invertTree(root *TreeNode) *TreeNode {
	if root == nil {
		return root
	}
	root.Left, root.Right = root.Right, root.Left
	invertTree(root.Left)
	invertTree(root.Right)
	return root
}

func main() {
	nodes := []interface{}{4, 2, 7, 1, 3, 6, 9}
	tree := &TreeNode{}
	tree.Init(nodes)
	tree = invertTree(tree)
	tree.Print()
}
