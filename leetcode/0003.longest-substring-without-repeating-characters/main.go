package main

import (
	"fmt"
)

func lengthOfLongestSubstring(s string) int {
	max := 0
	m := make(map[byte]int)
	for i := 0; i < len(s); i++ {
		v := s[i]
		// 如果遇到重复的，重置m，退回到重复元素所在位置的后一个开始检查新的字串
		if _, ok := m[v]; ok {
			i = m[v]
			m = make(map[byte]int)
			continue
		}
		m[v] = i
		if len(m) > max {
			max = len(m)
		}
	}
	return max
}

func lengthOfLongestSubstring2(s string) int {
	max := 0
	m := map[byte]int{}
	l := 0
	r := 0
	for i := 0; i < len(s); i++ {
		v := s[i]
		if _, ok := m[v]; ok && l <= m[v] {
			l = m[v] + 1
		}
		m[v] = i
		r += 1
		if r-l > max {
			max = r - l
		}
	}
	return max
}

func main() {
	fmt.Println(lengthOfLongestSubstring2("abcaccdeb"))
	fmt.Println(lengthOfLongestSubstring2("pwwkew"))
	fmt.Println(lengthOfLongestSubstring2("dvdf"))
	fmt.Println(lengthOfLongestSubstring2("aaa"))
}
