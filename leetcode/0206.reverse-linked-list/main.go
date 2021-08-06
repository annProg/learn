/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */

package main

import (
	"leetcode/libs/linkedlist"
)

type ListNode = linkedlist.ListNode

func reverseList(head *ListNode) *ListNode {
	if head == nil || head.Next == nil {
		return head
	}
	current := head
	tail := head
	for tail.Next != nil {
		current = tail
		tail = tail.Next
	}
	current.Next = nil
	tail.Next = reverseList(head)
	return tail
}

func reverseList2(head *ListNode) *ListNode {
	if head == nil || head.Next == nil {
		return head
	}
	newHead := reverseList(head.Next)
	head.Next.Next = head
	head.Next = nil
	return newHead
}

func reverseList3(head *ListNode) *ListNode {
	var prev *ListNode
	curr := head
	for curr != nil {
		next := curr.Next
		curr.Next = prev
		prev = curr
		curr = next
	}
	return prev
}

// 剑指 Offer 06. 从尾到头打印链表
func reversePrint(head *ListNode) []int {
	count := 0
	cur := head
	for cur != nil {
		count++
		cur = cur.Next
	}
	res := make([]int, count)
	cur = head
	for cur != nil {
		res[count-1] = cur.Val
		cur = cur.Next
		count--
	}
	return res
}

func main() {
	a := []int{1, 2, 3, 4, 5}
	head := new(ListNode)
	head.Init(a)
	//PrintList(head)
	head = reverseList3(head)
	head.Print()
}
