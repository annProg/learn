package main

import "fmt"

func longestCommonPrefix(strs []string) string {
	result := ""
	for i := 0; ; i++ {
		flag := 1
		var require byte = 0
		out := 0
		for _, s := range strs {

			if i >= len(s) {
				out = 1
				break
			}
			if require != 0 && s[i] != require {
				flag = 0
				out = 1
				break
			} else {
				require = s[i]
			}
		}

		if out == 1 {
			break
		}
		if flag == 1 {
			result += string(strs[0][i])
		}
	}
	return result
}

func longestCommonPrefix2(strs []string) string {
	if len(strs) == 0 {
		return ""
	}
	for i := 0; i < len(strs[0]); i++ {
		for j := 1; j < len(strs); j++ {
			if i == len(strs[j]) || strs[j][i] != strs[0][i] {
				return strs[0][:i]
			}
		}
	}
	return strs[0]
}

func main() {
	s := []string{"cir", "car"}
	fmt.Println(longestCommonPrefix(s))
	fmt.Println(longestCommonPrefix2(s))
}
