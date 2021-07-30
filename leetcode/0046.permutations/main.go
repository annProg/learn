package main

import (
	"fmt"
)

func permute(nums []int) [][]int {
	L := len(nums)
	path := []int{}
	used := make([]int, L)

	res := [][]int{}
	dfs(nums, L, 0, path, used, &res)
	return res
}

func dfs(nums []int, L int, depth int, path []int, used []int, res *[][]int) {
	if depth == L {
		tmp := make([]int, L)
		copy(tmp, path)
		// 如果直接用 path, 由于切片是引用类型，后续递归可能会再次操作此切片，导致数据被修改，因此需要复制出来
		*res = append(*res, tmp)
		return
	}

	for i, num := range nums {
		if used[i] == 1 {
			continue
		}
		path = append(path, num)
		used[i] = 1
		dfs(nums, L, depth+1, path, used, res)
		path = path[0 : len(path)-1]
		used[i] = 0
	}
}

func main() {
	fmt.Println(permute([]int{5, 4, 6, 2}))
}
