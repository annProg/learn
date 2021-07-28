package tree

import "fmt"

//Definition for a binary tree node.
type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

func (root *TreeNode) preorderTraversal() []int {
	ret := []int{}
	if root == nil {
		return ret
	}
	ret = append(ret, root.Val)
	ret = append(ret, root.Left.preorderTraversal()...)
	ret = append(ret, root.Right.preorderTraversal()...)
	return ret
}

func (root *TreeNode) inorderTraversal() []int {
	ret := []int{}
	if root == nil {
		return ret
	}
	ret = append(ret, root.Left.inorderTraversal()...)
	ret = append(ret, root.Val)
	ret = append(ret, root.Right.inorderTraversal()...)
	return ret
}

func (root *TreeNode) postorderTraversal() []int {
	ret := []int{}
	if root == nil {
		return ret
	}
	ret = append(ret, root.Left.postorderTraversal()...)
	ret = append(ret, root.Right.postorderTraversal()...)
	ret = append(ret, root.Val)
	return ret
}

func (root *TreeNode) levelOrder() [][]int {
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

func (root *TreeNode) maxDepth() int {
	depth := 0
	if root == nil {
		return depth
	}
	depth += 1
	left := depth + root.Left.maxDepth()
	right := depth + root.Right.maxDepth()
	if left >= right {
		return left
	}
	return right
}

func (root *TreeNode) isSymmetric() bool {
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

func (root *TreeNode) Init(els []interface{}) {
	queue := []*TreeNode{}
	queue = append(queue, root)
	if els[0] == nil {
		root = nil
		return
	}
	root.Val = els[0].(int)
	for i := 0; i+2 < len(els); i = i + 2 {
		queue[0].Left = &TreeNode{}
		queue[0].Right = &TreeNode{}
		queue = append(queue, queue[0].Left, queue[0].Right)
		assign(queue[0], els[i+1], els[i+2])
		queue = queue[1:]
	}
}

func assign(tree *TreeNode, left, right interface{}) {
	if left == nil {
		tree.Left = nil
	} else if right == nil {
		tree.Right = nil
	} else {
		tree.Left.Val = left.(int)
		tree.Right.Val = right.(int)
	}
}

func (root *TreeNode) Print() {
	ret := root.levelOrder()
	fmt.Println(ret)
}
