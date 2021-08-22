package main

import (
	"leetcode/libs/linkedlist"
)

type ListNode = linkedlist.ListNode

// 两个指针，走到链表结尾后在走另一个链表，这样走的总数一样，第二遍走的时候一定会同时到结尾
func getIntersectionNode(headA, headB *ListNode) *ListNode {
	curA, curB := headA, headB
	for curA != nil || curB != nil {
		if curA == curB {
			return curA
		}
		if curA == nil {
			curA = headB
			curB = curB.Next
		} else if curB == nil {
			curB = headA
			curA = curA.Next
		} else {
			curA = curA.Next
			curB = curB.Next
		}
	}
	return nil
}

func getTail(l *ListNode) *ListNode {
	c := l
	for c.Next != nil {
		c = c.Next
	}
	return c
}

func main() {
	l1, l2, l3 := new(ListNode), new(ListNode), new(ListNode)
	l1.Init([]int{1, 2})
	l2.Init([]int{3, 6, 9})
	l3.Init([]int{8, 4, 5})
	t1 := getTail(l1)
	t2 := getTail(l2)
	t1.Next = l3
	t2.Next = l3
	l := getIntersectionNode(l1, l2)
	l.Print()
}
