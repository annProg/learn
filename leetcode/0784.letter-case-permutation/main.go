package main

import "fmt"

func letterCasePermutation(s string) []string {
	chs := []byte(s)
	L := len(chs)
	res := []string{}
	dfs(chs, L, 0, &res)
	return res
}

func dfs(chs []byte, n, start int, res *[]string) {
	// 每一层搜索都是一个合法的答案
	*res = append(*res, string(chs))
	for i := start; i < n; i++ {
		// A->65, a->97
		if chs[i] >= 65 {
			tmp := chs[i]
			// 改变大小写后继续往后搜索
			if chs[i] < 97 {
				chs[i] = chs[i] + 32
			} else {
				chs[i] = chs[i] - 32
			}
			dfs(chs, n, i+1, res)
			// 回溯
			chs[i] = tmp
		}
	}
}

func main() {
	fmt.Println(letterCasePermutation("1ab"))
}
