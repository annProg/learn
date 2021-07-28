package main

// Definition for a Node.
type Node struct {
	Val   int
	Left  *Node
	Right *Node
	Next  *Node
}

func connect(root *Node) *Node {
	if root == nil {
		return nil
	}
	que := []*Node{}
	que = append(que, root)

	for len(que) > 0 {
		level := que
		que = nil
		for i, node := range level {
			if i+1 < len(level) {
				node.Next = level[i+1]
			}
			if node.Left != nil {
				que = append(que, node.Left)
			}
			if node.Right != nil {
				que = append(que, node.Right)
			}
		}
	}
	return root
}
func main() {
	tree := &Node{Val: 1, Left: &Node{Val: 2}, Right: &Node{Val: 3}}
	tree.Left.Left = &Node{Val: 4}
	tree.Left.Right = &Node{Val: 5}
	tree.Right.Left = &Node{Val: 6}
	tree.Right.Right = &Node{Val: 7}
	tree = connect(tree)
}
