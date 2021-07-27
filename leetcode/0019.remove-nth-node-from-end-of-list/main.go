package main

import "leetcode/libs/linkedlist"

type ListNode = linkedlist.ListNode

func removeNthFromEnd(head *ListNode, n int) *ListNode {
	l := 0
	pos := 0
	prev, cur := head, head
	for cur != nil {
		if l-n > pos {
			prev = prev.Next
			pos++
		}
		l++
		cur = cur.Next
	}
	if l == n {
		return head.Next
	} else {
		prev.Next = prev.Next.Next
	}
	return head
}

func main() {
	a := []int{1, 2, 3, 4}
	head := new(ListNode)
	head.Init(a)
	head = removeNthFromEnd(head, 2)
	head.Print()
}
