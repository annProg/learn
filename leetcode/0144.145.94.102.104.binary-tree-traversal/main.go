package main

import "fmt"

//Definition for a binary tree node.
type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

func preorderTraversal(root *TreeNode) []int {
	ret := []int{}
	if root == nil {
		return ret
	}
	ret = append(ret, root.Val)
	ret = append(ret, preorderTraversal(root.Left)...)
	ret = append(ret, preorderTraversal(root.Right)...)
	return ret
}

func inorderTraversal(root *TreeNode) []int {
	ret := []int{}
	if root == nil {
		return ret
	}
	ret = append(ret, inorderTraversal(root.Left)...)
	ret = append(ret, root.Val)
	ret = append(ret, inorderTraversal(root.Right)...)
	return ret
}

func postorderTraversal(root *TreeNode) []int {
	ret := []int{}
	if root == nil {
		return ret
	}
	ret = append(ret, postorderTraversal(root.Left)...)
	ret = append(ret, postorderTraversal(root.Right)...)
	ret = append(ret, root.Val)
	return ret
}

func levelOrder(root *TreeNode) [][]int {
	ret := [][]int{}
	if root == nil {
		return ret
	}
	que := []*TreeNode{}
	level := []*TreeNode{}
	que = append(que, root)

	for len(que) > 0 {
		for len(que) > 0 {
			level = append(level, que[len(que)-1])
			que = que[0 : len(que)-1]
		}
		vals := []int{}
		for len(level) > 0 {
			node := level[len(level)-1]
			level = level[0 : len(level)-1]
			vals = append(vals, node.Val)
			if node.Left != nil {
				que = append(que, node.Left)
			}
			if node.Right != nil {
				que = append(que, node.Right)
			}
		}
		ret = append(ret, vals)
	}
	return ret
}

func maxDepth(root *TreeNode) int {
	depth := 0
	if root == nil {
		return depth
	}
	depth += 1
	left := depth + maxDepth(root.Left)
	right := depth + maxDepth(root.Right)
	if left >= right {
		return left
	}
	return right
}

func isSymmetric(root *TreeNode) bool {
	if root == nil {
		return false
	}
	return check(root.Left, root.Right)
}

func check(left, right *TreeNode) bool {
	if left == nil && right == nil {
		return true
	}
	if left == nil && right != nil {
		return false
	}
	if left != nil && right == nil {
		return false
	}
	if left.Val != right.Val {
		return false
	}
	lr := check(left.Left, right.Right)
	rl := check(left.Right, right.Left)
	return lr && rl
}

func main() {
	tree := &TreeNode{Val: 1}
	tree.Right = &TreeNode{Val: 2}
	tree.Right.Left = &TreeNode{Val: 3}
	fmt.Println(preorderTraversal(tree))
	fmt.Println(inorderTraversal(tree))
	fmt.Println(postorderTraversal(tree))
	fmt.Println(levelOrder(tree))
	fmt.Println(maxDepth(tree))
	fmt.Println(isSymmetric(tree))
}
