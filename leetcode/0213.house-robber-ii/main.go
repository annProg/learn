package main

// 和 198 题类似，由于 第一个 和 最后一个不能同时偷，那么就可以分别把第一个和最后一个去掉计算，然后取两种情况下大的一个
func rob(nums []int) int {
	L := len(nums)
	if L == 1 {
		return nums[0]
	}
	if L == 2 {
		return max(nums[0], nums[1])
	}
	f1 := doRob(nums[0 : L-1])
	f2 := doRob(nums[1:])
	return max(f1, f2)
}

func doRob(nums []int) int {
	L := len(nums)
	p2, p1 := nums[0], max(nums[0], nums[1])
	m := max(p2, p1)
	for i := 2; i < L; i++ {
		p := max(p2+nums[i], p1)
		if p > m {
			m = p
		}
		p2 = p1
		p1 = p
	}
	return m
}

func max(a, b int) int {
	if a >= b {
		return a
	}
	return b
}

func main() {

}
