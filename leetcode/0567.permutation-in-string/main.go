package main

import "fmt"

// 超出时间限制
func checkInclusion(s1 string, s2 string) bool {
	l1 := len(s1)
	l2 := len(s2)
	m := map[byte]int{}
	for i := 0; i < l1; i++ {
		m[s1[i]]++
	}

	for i := 0; i < l2; i++ {
		end := i + l1
		if end > l2 {
			return false
		}
		sub := map[byte]int{}
		for j := i; j < end; j++ {
			if m[s2[j]] == 0 {
				break
			} else {
				sub[s2[j]]++
			}
		}

		if len(sub) == len(m) {
			flag := true
			for k, v := range sub {
				if v != m[k] {
					flag = false
					break
				}
			}
			if flag {
				return true
			}
		}
	}
	return false
}

// 超时
func checkInclusion2(s1 string, s2 string) bool {
	l1 := len(s1)
	l2 := len(s2)
	m := map[byte]int{}
	for i := 0; i < l1; i++ {
		m[s1[i]]++
	}

	left, right := 0, 0

	sub := map[byte]int{}
	for right <= l2 {
		if right-left == l1 || right == l2 {
			if check(sub, m) {
				return true
			} else {
				sub = map[byte]int{}
				left++
				right = left
			}
		} else {
			sub[s2[right]]++
			right++
		}
	}
	return false
}

func check(sub, m map[byte]int) bool {
	for k, v := range sub {
		if v != m[k] {
			return false
		}
	}
	return true
}

// 滑动窗口
func checkInclusion3(s1 string, s2 string) bool {
	l1 := len(s1)
	l2 := len(s2)
	if l2 < l1 {
		return false
	}
	l, r := 0, l1-1
	m1 := [26]int{}
	m2 := [26]int{}
	for i := 0; i < l1; i++ {
		m1[s1[i]-'a']++
	}
	for i := 0; i < l1-1; i++ {
		m2[s2[i]-'a']++
	}
	for r < l2 {
		m2[s2[r]-'a']++
		fmt.Println(m2, m1)
		if m1 == m2 {
			return true
		}
		m2[s2[l]-'a']--
		l++
		r++
	}
	return false
}

func main() {
	fmt.Println(checkInclusion3("ab", "eidbaooo"))
}
