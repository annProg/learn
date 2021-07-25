/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func removeElements(head *ListNode, val int) *ListNode {
	for head != nil {
		if head.Val == val {
			head = head.Next
		} else {
			break
		}
	}
	if head == nil {
		return nil
	}
	cur := head.Next
	prev := head
	for cur != nil {
		if cur.Val == val {
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

// 官方题解
func removeElements2(head *ListNode, val int) *ListNode {
	dummyHead := &ListNode{Next: head}
	for tmp := dummyHead; tmp.Next != nil; {
		if tmp.Next.Val == val {
			tmp.Next = tmp.Next.Next
		} else {
			tmp = tmp.Next
		}
	}
	return dummyHead.Next
}
