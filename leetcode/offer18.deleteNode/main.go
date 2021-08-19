package main

import "leetcode/libs/linkedlist"

type ListNode = linkedlist.ListNode

func deleteNode(head *ListNode, val int) *ListNode {
	dummy := &ListNode{}
	dummy.Next = head

	prev := dummy
	cur := head
	for cur != nil {
		if cur.Val == val {
			prev.Next = cur.Next
		} else {
			prev = cur
		}
		cur = cur.Next
	}
	return dummy.Next
}

func main() {
	nodes := []int{4, 5, 1, 9}
	link := new(ListNode)
	link.Init(nodes)
	link = deleteNode(link, 4)
	link.Print()
}
