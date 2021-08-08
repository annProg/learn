package main

import "leetcode/libs/linkedlist"

type ListNode = linkedlist.ListNode

func deleteDuplicates(head *ListNode) *ListNode {
	if head == nil {
		return nil
	}
	dummy := &ListNode{Val: -200, Next: head}
	prev, cur := dummy, head
	dup := false
	for cur.Next != nil {
		if cur.Val == cur.Next.Val {
			dup = true
		}
		if cur.Val != cur.Next.Val {
			if dup {
				prev.Next = cur.Next
				dup = false
			} else {
				prev = cur
			}
		}
		cur = cur.Next
	}
	// 如果一直到结尾都是重复的，应将结尾都删除
	if dup {
		prev.Next = nil
	}
	return dummy.Next
}

func main() {
	nums := []int{1, 1, 1}
	head := new(ListNode)
	head.Init(nums)
	head.Print()
	head = deleteDuplicates(head)
	head.Print()
}
