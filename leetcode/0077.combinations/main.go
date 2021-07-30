package main

import "fmt"

func combine(n int, k int) [][]int {
	nums := make([]int, n)
	for i := 0; i < n; i++ {
		nums[i] = i + 1
	}
	path := []int{}

	res := [][]int{}
	dfs(n, k, 1, 0, path, &res)
	return res
}

func dfs(n int, k int, start int, depth int, path []int, res *[][]int) {
	if depth == k {
		tmp := make([]int, k)
		copy(tmp, path)
		// 如果直接用 path, 由于切片是引用类型，后续递归可能会再次操作此切片，导致数据被修改，因此需要复制出来
		*res = append(*res, tmp)
		return
	}

	// 剪枝
	for i := start; i <= n-(k-len(path))+1; i++ {
		path = append(path, i)
		dfs(n, k, i+1, depth+1, path, res)
		path = path[0 : len(path)-1]
	}
}

func main() {
	fmt.Println(combine(3, 2))
}
