package main

import "leetcode/libs/linkedlist"

type ListNode = linkedlist.ListNode

func getKthFromEnd(head *ListNode, k int) *ListNode {
	fast, slow := head, head
	for i := 0; i < k; i++ {
		fast = fast.Next
	}
	for fast != nil {
		fast = fast.Next
		slow = slow.Next
	}
	return slow
}

func main() {
	head := new(ListNode)
	head.Init([]int{1, 2, 3, 4, 5})
	head = getKthFromEnd(head, 2)
	head.Print()
}
