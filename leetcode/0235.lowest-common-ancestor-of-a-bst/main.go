package main

import (
	"fmt"
	"leetcode/libs/tree"
)

type TreeNode = tree.TreeNode

func lowestCommonAncestor(root, p, q *TreeNode) *TreeNode {
	if (p.Val <= root.Val && q.Val >= root.Val) || (p.Val >= root.Val && q.Val <= root.Val) {
		return root
	} else if p.Val < root.Val && q.Val < root.Val {
		return lowestCommonAncestor(root.Left, p, q)
	} else {
		return lowestCommonAncestor(root.Right, p, q)
	}
}

func main() {
	nodes := []interface{}{6, 2, 8, 0, 4, 7, 9, nil, nil, 3, 5}
	tree := &TreeNode{}
	tree.Init(nodes)
	fmt.Println(lowestCommonAncestor(tree, &TreeNode{Val: 2}, &TreeNode{Val: 4}))
}
