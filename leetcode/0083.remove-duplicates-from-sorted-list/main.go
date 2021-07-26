package main

import "leetcode/libs/linkedlist"

type ListNode = linkedlist.ListNode

func deleteDuplicates(head *ListNode) *ListNode {
	if head == nil || head.Next == nil {
		return head
	}
	prev := head
	cur := prev.Next
	for cur != nil {
		if prev.Val == cur.Val {
			prev.Next = cur.Next
			cur.Next = nil
			cur = prev.Next
		} else {
			cur = cur.Next
			prev = prev.Next
		}
	}
	return head
}

func main() {
	a := []int{1, 1, 1, 2}
	head := new(ListNode)
	head.Init(a)
	head = deleteDuplicates(head)
	head.Print()
}
