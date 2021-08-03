package main

import "fmt"

// 10 15 20 5 x
//       x  x
// f(4) = min{f(3)+num[3], f(2) + num[2]} = min{20, 30} = 20
// 举例分析，要跳到 x 位置，可以从 20 或者 5 跳过去，从20跳过去，则意味着求楼顶为 2 时的花费，加上20（20不是楼顶后要算体力）就是这种情况的花费，即 f(2) + num[2]，同理 从 5 跳过去 花费是 f(3) + num[3]，比较这两者哪个小即可
// 初始情况，跳到 0 或者 1 为楼顶时，可以直接跳到楼顶，花费为0

func minCostClimbingStairs(cost []int) int {
	n := len(cost)

	f0, f1, f := 0, 0, 0

	for i := 2; i <= n; i++ {
		if f0+cost[i-2] < f1+cost[i-1] {
			f = f0 + cost[i-2]
		} else {
			f = f1 + cost[i-1]
		}
		f0 = f1
		f1 = f
	}
	return f
}

func main() {
	fmt.Println(minCostClimbingStairs([]int{1, 100, 1, 1, 1, 100, 1, 1, 100, 1}))
	fmt.Println(minCostClimbingStairs([]int{10, 15, 20}))
}
