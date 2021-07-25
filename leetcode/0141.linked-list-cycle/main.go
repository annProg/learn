/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func hasCycle(head *ListNode) bool {
	if head == nil || head.Next == nil {
		return false
	}

	m := map[*ListNode]int{}

	cur := head
	for {
		m[cur]++
		cur = cur.Next
		if _, ok := m[cur]; ok {
			return true
		}
		if cur.Next == nil {
			return false
		}
	}
	return false
}

// 快慢指针
func hasCycle2(head *ListNode) bool {
	if head == nil || head.Next == nil {
		return false
	}
	slow, fast := head, head.Next
	for fast != nil && fast.Next != nil {
		if slow == fast || fast.Next == slow {
			return true
		}
		slow = slow.Next
		fast = fast.Next.Next
	}
	return false
}