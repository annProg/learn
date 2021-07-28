package tree

import "fmt"

//Definition for a binary tree node.
type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

func (root *TreeNode) PreorderTraversal() []int {
	ret := []int{}
	if root == nil {
		return ret
	}
	ret = append(ret, root.Val)
	ret = append(ret, root.Left.PreorderTraversal()...)
	ret = append(ret, root.Right.PreorderTraversal()...)
	return ret
}

func (root *TreeNode) InorderTraversal() []int {
	ret := []int{}
	if root == nil {
		return ret
	}
	ret = append(ret, root.Left.InorderTraversal()...)
	ret = append(ret, root.Val)
	ret = append(ret, root.Right.InorderTraversal()...)
	return ret
}

func (root *TreeNode) PostorderTraversal() []int {
	ret := []int{}
	if root == nil {
		return ret
	}
	ret = append(ret, root.Left.PostorderTraversal()...)
	ret = append(ret, root.Right.PostorderTraversal()...)
	ret = append(ret, root.Val)
	return ret
}

func (root *TreeNode) LevelOrder() [][]int {
	ret := [][]int{}
	if root == nil {
		return ret
	}
	que := []*TreeNode{}
	que = append(que, root)

	for len(que) > 0 {
		level := que
		que = nil
		vals := []int{}
		for _, node := range level {
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

func (root *TreeNode) MaxDepth() int {
	depth := 0
	if root == nil {
		return depth
	}
	depth += 1
	left := depth + root.Left.MaxDepth()
	right := depth + root.Right.MaxDepth()
	if left >= right {
		return left
	}
	return right
}

func (root *TreeNode) IsSymmetric() bool {
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
	for i := 0; i+1 < len(els); i = i + 2 {
		var r interface{}
		if i+2 >= len(els) {
			r = nil
		} else {
			r = els[i+2]
		}
		queue = append(queue, assign(queue[0], els[i+1], r)...)
		queue = queue[1:]
	}
}

func assign(tree *TreeNode, left, right interface{}) []*TreeNode {
	ret := []*TreeNode{}
	if left != nil {
		tree.Left = &TreeNode{Val: left.(int)}
		ret = append(ret, tree.Left)
	}
	if right != nil {
		tree.Right = &TreeNode{Val: right.(int)}
		ret = append(ret, tree.Right)
	}
	return ret
}

func (root *TreeNode) Print() {
	ret := root.LevelOrder()
	fmt.Println(ret)
}
