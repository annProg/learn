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

func main() {
	fmt.Println(lengthOfLongestSubstring("abcaccdeb"))
	fmt.Println(lengthOfLongestSubstring("pwwkew"))
	fmt.Println(lengthOfLongestSubstring("dvdf"))
	fmt.Println(lengthOfLongestSubstring("abcabcbb"))
}
