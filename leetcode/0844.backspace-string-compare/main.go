package main

import "fmt"

// 栈，空间复杂度高
func backspaceCompare(s string, t string) bool {
	as := stack(s)
	at := stack(t)
	if len(as) != len(at) {
		return false
	}
	for i := 0; i < len(as); i++ {
		if as[i] != at[i] {
			return false
		}
	}
	return true
}

func stack(s string) []byte {
	res := []byte{}
	for i := 0; i < len(s); i++ {
		if s[i] != '#' {
			res = append(res, s[i])
		} else {
			if len(res) > 0 {
				res = res[0 : len(res)-1]
			}
		}
	}
	return res
}

// 官方 双指针
func backspaceCompare2(s, t string) bool {
	skipS, skipT := 0, 0
	i, j := len(s)-1, len(t)-1
	for i >= 0 || j >= 0 {
		for i >= 0 {
			if s[i] == '#' {
				skipS++
				i--
			} else if skipS > 0 {
				skipS--
				i--
			} else {
				break
			}
		}
		for j >= 0 {
			if t[j] == '#' {
				skipT++
				j--
			} else if skipT > 0 {
				skipT--
				j--
			} else {
				break
			}
		}
		if i >= 0 && j >= 0 {
			if s[i] != t[j] {
				return false
			}
		} else if i >= 0 || j >= 0 {
			return false
		}
		i--
		j--
	}
	return true
}

func main() {
	fmt.Println(backspaceCompare("ab#c", "ad#c"))
}
