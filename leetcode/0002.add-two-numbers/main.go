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

func addTwoNumbers(l1 *ListNode, l2 *ListNode) *ListNode {
	var item *ListNode = new(ListNode)
	if l1 == nil {
		l1 = &ListNode{0, nil}
	}
	if l2 == nil {
		l2 = &ListNode{0, nil}
	}
	item.Val = l1.Val + l2.Val
	// 进位
	if item.Val >= 10 {
		item.Val -= 10
		if l1.Next == nil {
			l1.Next = &ListNode{1, nil}
		} else {
			l1.Next.Val += 1
		}
	}

	// 都没有数字时退出
	if l1.Next == nil && l2.Next == nil {
		return item
	}

	item.Next = addTwoNumbers(l1.Next, l2.Next)

	return item
}

func main() {
	var l1 *ListNode = &ListNode{9, &ListNode{9, &ListNode{9, &ListNode{9, nil}}}}
	var l2 *ListNode = &ListNode{9, &ListNode{9, &ListNode{9, nil}}}

	var result *ListNode = addTwoNumbers(l1, l2)

	for result != nil {
		fmt.Println(result.Val)
		result = result.Next
	}
}
