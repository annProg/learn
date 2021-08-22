package main

import "fmt"

func reverseWords(s string) string {
	s = trim(s)
	if s == "" {
		return s
	}
	res := []string{}
	L := len(s)
	l, r := L-1, L-1
	for r >= 0 && l > 0 {
		if s[l] == ' ' {
			res = append(res, s[l+1:r+1])
			for l > 0 {
				if s[l] == ' ' {
					l--
				} else {
					break
				}
			}
			r = l
		} else {
			l--
		}
	}
	res = append(res, s[0:r+1])
	var ss string
	for i := 0; i < len(res)-1; i++ {
		if res[i] != " " {
			ss = ss + res[i] + " "
		}
	}
	ss = ss + res[len(res)-1]
	return ss
}

func trim(s string) string {
	if s == "" {
		return s
	}
	l, r := 0, len(s)-1
	for l <= r {
		if s[l] == ' ' {
			l++
		} else if s[r] == ' ' {
			r--
		} else {
			break
		}
	}
	return s[l : r+1]
}

func main() {
	fmt.Println(reverseWords(" hello    world!            "))
}
