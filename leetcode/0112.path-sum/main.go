package main

import (
	"fmt"
	"leetcode/libs/tree"
)

type TreeNode = tree.TreeNode

func hasPathSum(root *TreeNode, targetSum int) bool {
	if root == nil {
		return false
	}
	sum := 0
	stack := []*TreeNode{}
	stack = append(stack, root)
	for len(stack) > 0 {
		node := stack[len(stack)-1]
		sum += node.Val
		if node.Left == nil && node.Right == nil {
			if sum == targetSum {
				return true
			} else {
				for node.Right == nil && node.Left == nil {
					sum -= node.Val
					stack = stack[0 : len(stack)-1]
					if len(stack) == 0 {
						// 删完了
						return false
					}
					node = stack[len(stack)-1]
					// 因为是前序遍历，先算的Left，所以把 Left 删除
					if node.Left != nil && node.Right != nil {
						node.Left = nil
					} else {
						node.Left = nil
						node.Right = nil
					}
				}
			}
		}

		if node.Left != nil {
			stack = append(stack, node.Left)
		} else if node.Right != nil {
			stack = append(stack, node.Right)
		}
	}
	return false
}

// 递归
func hasPathSum2(root *TreeNode, targetSum int) bool {
	if root == nil {
		return false
	}
	if root.Left == nil && root.Right == nil && root.Val == targetSum {
		return true
	} else {
		return hasPathSum2(root.Left, targetSum-root.Val) || hasPathSum2(root.Right, targetSum-root.Val)
	}
}

func main() {
	nodes := []interface{}{5, 4, 8, 11, nil, 13, 4, 7, 2, nil, nil, nil, 1}
	//nodes := []interface{}{1, 2, 3}
	tree := &TreeNode{}
	tree.Init(nodes)
	fmt.Println(hasPathSum(tree, 22))
}
