package main

import "fmt"

func reverseWords2(s string) string {
	ss := []byte(s)
	l, r, pos := 0, -1, 0
	for i := 0; i < len(ss); i++ {
		if ss[i] == ' ' {
			pos = r
			reverse2(ss, l, r)
			l, r = pos+2, pos+2
			i++
		} else if i == len(ss)-1 {
			reverse2(ss, l, r+1)
		} else {
			r++
		}
	}
	return string(ss)
}

func reverse2(ss []byte, l, r int) {
	for l < r {
		ss[l], ss[r] = ss[r], ss[l]
		l++
		r--
	}
}

func reverseWords(s string) string {
	word := []byte{}
	ret := ""
	for i := 0; i < len(s); i++ {
		if s[i] == ' ' {
			ret += string(reverse(word)) + " "
			word = []byte{}
		} else {
			word = append(word, s[i])
		}
	}
	if len(word) > 0 {
		ret += string(reverse(word))
	}
	return ret
}

func reverse(s []byte) []byte {
	l := 0
	r := len(s) - 1
	for l < r {
		s[l], s[r] = s[r], s[l]
		l++
		r--
	}
	return s
}

func main() {
	//fmt.Println(reverseWords("ab cd"))
	fmt.Println(reverseWords2("ab cd ef"))
}
