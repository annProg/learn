package main

import (
	"fmt"
	"leetcode/libs/tree"
)

type TreeNode = tree.TreeNode

func isSubStructure(A *TreeNode, B *TreeNode) bool {
	if A == nil || B == nil {
		return false
	}
	return dfs(A, B) || isSubStructure(A.Left, B) || isSubStructure(A.Right, B)
}

func dfs(A *TreeNode, B *TreeNode) bool {
	if B == nil {
		return true
	}
	if A == nil {
		return false
	}
	return A.Val == B.Val && dfs(A.Left, B.Left) && dfs(A.Right, B.Right)
}

func main() {
	a := []interface{}{2, 3, 2, 1}
	b := []interface{}{3, nil, 2, 2}
	ta := new(TreeNode)
	tb := new(TreeNode)
	ta.Init(a)
	tb.Init(b)
	fmt.Println(isSubStructure(ta, tb))
}
