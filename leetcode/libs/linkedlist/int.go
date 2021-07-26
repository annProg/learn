package linkedlist

import "fmt"

type ListNode struct {
	Val  int
	Next *ListNode
}

func (head *ListNode) Init(a []int) {
	head.Val = a[0]
	current := head
	for i := 1; i < len(a); i++ {
		node := new(ListNode)
		node.Val = a[i]
		current.Next = node
		current = current.Next
	}
}

func (head *ListNode) Print() {
	a := []int{}
	current := head
	for current != nil {
		a = append(a, current.Val)
		current = current.Next
	}
	fmt.Println(a)
}
