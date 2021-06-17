package main

import "fmt"

func isValid(s string) bool {
	if len(s)%2 != 0 {
		return false
	}
	stack := make([]byte, 0)
	m := map[byte]byte{'(': ')', '{': '}', '[': ']'}
	for i := 0; i < len(s); i++ {
		if _, ok := m[s[i]]; ok {
			stack = append(stack, s[i])
		} else {
			if len(stack) > 0 && m[stack[len(stack)-1]] == s[i] {
				// 出栈
				stack = stack[0 : len(stack)-1]
			} else {
				return false
			}
		}
	}
	if len(stack) == 0 {
		return true
	}
	return false
}

func main() {
	fmt.Println(isValid("()"))
}
