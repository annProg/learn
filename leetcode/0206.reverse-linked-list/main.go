/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */

package main

import "fmt"

type ListNode struct {
	Val  int
	Next *ListNode
}

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

func Init(a []int) *ListNode {
	head := new(ListNode)
	head.Val = a[0]
	current := head
	for i := 1; i < len(a); i++ {
		node := new(ListNode)
		node.Val = a[i]
		current.Next = node
		current = current.Next
	}
	return head
}

func PrintList(head *ListNode) {
	a := []int{}
	current := head
	for current != nil {
		a = append(a, current.Val)
		current = current.Next
	}
	fmt.Println(a)
}

func main() {
	a := []int{1, 2, 3, 4, 5}
	head := Init(a)
	//PrintList(head)
	PrintList(reverseList3(head))
}
