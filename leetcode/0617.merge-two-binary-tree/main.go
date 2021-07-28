package main

import "leetcode/libs/tree"

type TreeNode = tree.TreeNode

func mergeTrees(root1 *TreeNode, root2 *TreeNode) *TreeNode {
	if root1 == nil {
		return root2
	}
	if root2 == nil {
		return root1
	}
	root1.Val += root2.Val
	root1.Left = mergeTrees(root1.Left, root2.Left)
	root1.Right = mergeTrees(root1.Right, root2.Right)

	return root1
}

func main() {
	n1 := []interface{}{1, 3, 2, 5}
	n2 := []interface{}{2, 1, 3, nil, 4, nil, 7}
	t1, t2 := &TreeNode{}, &TreeNode{}
	t1.Init(n1)
	t2.Init(n2)
	t1.Print()
	t2.Print()
	t1 = mergeTrees(t1, t2)
	t1.Print()
}
