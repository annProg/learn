package main

import "fmt"

type Ring struct {
	next, prev *Ring
	Value      interface{}
}

func (r *Ring) init() *Ring {
	r.next = r
	r.prev = r
	return r
}

// 获取下一个节点
func (r *Ring) Next() *Ring {
	if r.next == nil {
		return r.init()
	}
	return r.next
}

// 获取上一个节点
func (r *Ring) Prev() *Ring {
	if r.next == nil {
		return r.init()
	}
	return r.prev
}

// 创建N个节点的循环链表
func New(n int) *Ring {
	if n <= 0 {
		return nil
	}
	r := new(Ring)
	p := r
	for i := 1; i < n; i++ {
		p.next = &Ring{prev: p}
		p = p.next
	}
	p.next = r
	r.prev = p
	return r
}

func main() {
	r := new(Ring)
	r.init()
	fmt.Println(r)

	Node := New(10)
	current := Node
	for i := 0; i < 10; i++ {
		fmt.Println(current)
		current = current.next
	}
}
