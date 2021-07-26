package main

import "fmt"

type MyQueue struct {
	in, out []int
}

/** Initialize your data structure here. */
func Constructor() MyQueue {
	return MyQueue{}
}

/** Push element x to the back of queue. */
func (this *MyQueue) Push(x int) {
	this.in = append(this.in, x)
}

/** Removes the element from in front of queue and returns that element. */
func (this *MyQueue) Pop() int {
	item := this.Peek()
	this.out = this.out[0 : len(this.out)-1]
	return item
}

/** Get the front element. */
func (this *MyQueue) Peek() int {
	if len(this.out) == 0 {
		for len(this.in) > 0 {
			this.out = append(this.out, this.in[len(this.in)-1])
			this.in = this.in[0 : len(this.in)-1]
		}
	}
	return this.out[len(this.out)-1]
}

/** Returns whether the queue is empty. */
func (this *MyQueue) Empty() bool {
	if len(this.in) == 0 && len(this.out) == 0 {
		return true
	}
	return false
}

/**
 * Your MyQueue object will be instantiated and called as such:
 * obj := Constructor();
 * obj.Push(x);
 * param_2 := obj.Pop();
 * param_3 := obj.Peek();
 * param_4 := obj.Empty();
 */
func main() {
	obj := Constructor()
	obj.Push(1)
	obj.Push(1)
	obj.Push(2)
	fmt.Println(obj.Peek())
	fmt.Println(obj.Pop())
	fmt.Println(obj.Empty())
}
