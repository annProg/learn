package main

import "leetcode/libs/linkedlist"

type ListNode = linkedlist.ListNode

func middleNode(head *ListNode) *ListNode {
	r := head
	mid := head
	l := 0
	m := 0
	for r != nil {
		l++
		if l/2 > m {
			mid = mid.Next
			m = l / 2
		}
		r = r.Next
	}
	return mid
}

// 官方题解 快慢指针
func middleNode2(head *ListNode) *ListNode {
	slow, quick := head, head
	for quick != nil && quick.Next != nil {
		slow = slow.Next
		quick = quick.Next.Next
	}
	return slow
}

func main() {
	a := []int{1, 2, 3, 4}
	head := new(ListNode)
	head.Init(a)
	mid := middleNode2(head)
	mid.Print()
}
