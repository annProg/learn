package main

import (
	"fmt"
	"sync"
)

type LinkNode struct {
	Next  *LinkNode
	Value string
}

type LinkQueue struct {
	first *LinkNode
	last  *LinkNode
	size  int
	lock  sync.Mutex
}

func (queue *LinkQueue) Add(v string) {
	queue.lock.Lock()
	defer queue.lock.Unlock()

	if queue.first == nil {
		queue.first = new(LinkNode)
		queue.first.Value = v
		queue.last = queue.first
	} else {
		newNode := new(LinkNode)
		newNode.Value = v
		queue.last.Next = newNode
		queue.last = newNode
	}

	queue.size += 1
}

func (queue *LinkQueue) Remove() string {
	queue.lock.Lock()
	defer queue.lock.Unlock()

	if queue.size == 0 {
		panic("empty")
	}

	// first 出队
	firstNode := queue.first
	v := firstNode.Value

	queue.first = firstNode.Next
	queue.size -= 1
	return v
}

// 获取队列第一个元素（但不出队列）
func (queue *LinkQueue) Peek() string {
	if queue.size == 0 {
		panic("empty")
	}

	return queue.first.Value
}

func (queue *LinkQueue) Size() int {
	return queue.size
}

func (queue *LinkQueue) IsEmpty() bool {
	return queue.size == 0
}

func main() {
	lqueue := new(LinkQueue)
	lqueue.Add("cat")
	lqueue.Add("dog")
	lqueue.Add("tiger")
	lqueue.Add("monkey")

	fmt.Println("Size: ", lqueue.Size())
	fmt.Println("Empty: ", lqueue.IsEmpty())
	fmt.Println("Peek: ", lqueue.Peek())
	fmt.Println("Remove: ", lqueue.Remove())
	lqueue.Remove()
	fmt.Println("Last: ", lqueue.last.Value)
	lqueue.Remove()
	lqueue.Remove()
	fmt.Println("Empty: ", lqueue.IsEmpty())
}
