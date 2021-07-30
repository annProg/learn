package main

import (
	"fmt"
	"leetcode/libs/tree"
)

type TreeNode = tree.TreeNode

func findTarget(root *TreeNode, k int) bool {
	if root == nil {
		return false
	}
	return preorder(root, root, k)
}

func preorder(root, cur *TreeNode, k int) bool {
	if cur == nil {
		return false
	}
	need := k - cur.Val

	if need != cur.Val && findVal(root, need) {
		return true
	}
	if preorder(root, cur.Left, k) || preorder(root, cur.Right, k) {
		return true
	}
	return false
}

func findVal(root *TreeNode, k int) bool {
	if root == nil {
		return false
	}
	if k == root.Val {
		return true
	}
	if k > root.Val {
		return findVal(root.Right, k)
	} else {
		return findVal(root.Left, k)
	}
}

func findTarget2(root *TreeNode, k int) bool {
	m := make(map[int]int)
	return find(root, k, m)
}

func find(root *TreeNode, k int, m map[int]int) bool {
	if root == nil {
		return false
	}
	if _, ok := m[k-root.Val]; ok {
		return true
	}
	m[root.Val] = 1
	return find(root.Left, k, m) || find(root.Right, k, m)
}

func main() {
	nodes := []interface{}{2, 1, 3}
	tree := &TreeNode{}
	tree.Init(nodes)
	fmt.Println(findTarget2(tree, 4))
}
