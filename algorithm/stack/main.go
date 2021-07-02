package main

import (
	"fmt"
	"sync"
)

type LinkNode struct {
	Next  *LinkNode
	Value string
}

type LinkStack struct {
	root *LinkNode
	size int
	lock sync.Mutex
}

func (stack *LinkStack) Push(v string) {
	stack.lock.Lock()
	defer stack.lock.Unlock()

	// 栈顶为空，增加节点
	if stack.root == nil {
		stack.root = new(LinkNode)
		stack.root.Value = v
	} else {
		// 否则新元素插入链表的头部
		// 原来的链表
		preNode := stack.root

		// 新节点
		newNode := new(LinkNode)
		newNode.Value = v

		// 原来的链表链接到新元素后面
		newNode.Next = preNode
		// 将新节点放在头部
		stack.root = newNode
	}
	stack.size += 1
}

func (stack *LinkStack) Pop() string {
	stack.lock.Lock()
	defer stack.lock.Unlock()

	if stack.size == 0 {
		panic("empty")
	}

	// 顶部元素出栈
	topNode := stack.root
	v := topNode.Value

	// 将顶部元素的后继链接链上
	stack.root = topNode.Next

	stack.size -= 1

	return v
}

// 获取栈顶元素（但不出栈）
func (stack *LinkStack) Peek() string {
	if stack.size == 0 {
		panic("empty")
	}

	return stack.root.Value
}

func (stack *LinkStack) Size() int {
	return stack.size
}

func (stack *LinkStack) IsEmpty() bool {
	return stack.size == 0
}

func main() {
	lstack := new(LinkStack)

	lstack.Push("cat")
	lstack.Push("dog")

	fmt.Println("size", lstack.Size())
	fmt.Println("pop", lstack.Pop())
	fmt.Println("size", lstack.Size())
	fmt.Println("peek", lstack.Peek())
	fmt.Println("empty", lstack.IsEmpty())
}
