package main

import "leetcode/libs/tree"

type TreeNode = tree.TreeNode

func searchBST(root *TreeNode, val int) *TreeNode {
	if root == nil {
		return nil
	}
	if root.Val == val {
		return root
	} else if root.Val > val {
		return searchBST(root.Left, val)
	} else {
		return searchBST(root.Right, val)
	}
}

func insertIntoBST(root *TreeNode, val int) *TreeNode {
	if root == nil {
		return &TreeNode{Val: val}
	}
	cur := root
	if val < cur.Val {
		if cur.Left == nil {
			cur.Left = &TreeNode{Val: val}
		} else {
			insertIntoBST(cur.Left, val)
		}
	} else {
		if cur.Right == nil {
			cur.Right = &TreeNode{Val: val}
		} else {
			insertIntoBST(cur.Right, val)
		}
	}
	return root
}

func main() {
	nodes := []interface{}{4, 2, 7, 1, 3}
	tree := &TreeNode{}
	tree.Init(nodes)
	s := searchBST(tree, 2)
	s.Print()
	i := insertIntoBST(tree, 5)
	i.Print()
}
