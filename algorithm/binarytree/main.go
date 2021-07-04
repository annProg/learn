package main

import "fmt"

type TreeNode struct {
	Data  string
	Left  *TreeNode
	Right *TreeNode
}

func PreOrder(tree *TreeNode) {
	if tree == nil {
		return
	}

	// 根左右
	fmt.Print(tree.Data, " ")
	PreOrder(tree.Left)
	PreOrder(tree.Right)
}

func MidOrder(tree *TreeNode) {
	if tree == nil {
		return
	}

	// 左根右
	MidOrder(tree.Left)
	fmt.Print(tree.Data, " ")
	MidOrder(tree.Right)
}

func PostOrder(tree *TreeNode) {
	if tree == nil {
		return
	}

	// 左右根
	PostOrder(tree.Left)
	PostOrder(tree.Right)
	fmt.Print(tree.Data, " ")
}

func main() {
	t := &TreeNode{Data: "A"}
	t.Left = &TreeNode{Data: "B"}
	t.Right = &TreeNode{Data: "C"}
	t.Left.Left = &TreeNode{Data: "D"}
	t.Left.Right = &TreeNode{Data: "E"}
	t.Right.Left = &TreeNode{Data: "F"}

	fmt.Println("先序")
	PreOrder(t)
	fmt.Println("\n中序")
	MidOrder(t)
	fmt.Println("\n后序")
	PostOrder(t)
}
