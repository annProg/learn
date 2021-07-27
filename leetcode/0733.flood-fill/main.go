package main

import "fmt"

func floodFill(image [][]int, sr int, sc int, newColor int) [][]int {
	dfs(image, sr, sc, image[sr][sc], newColor)
	return image
}

// 深度优先搜索
func dfs(image [][]int, sr int, sc int, color int, newColor int) {
	r := len(image)
	c := len(image[0])
	if sr < 0 || sr >= r || sc < 0 || sc >= c || image[sr][sc] != color || color == newColor {
		return
	}
	image[sr][sc] = newColor

	dfs(image, sr-1, sc, color, newColor)
	dfs(image, sr+1, sc, color, newColor)
	dfs(image, sr, sc-1, color, newColor)
	dfs(image, sr, sc+1, color, newColor)
}

// 广度优先搜索
func floodFill2(image [][]int, sr int, sc int, newColor int) [][]int {
	oldColor := image[sr][sc]
	if oldColor == newColor {
		return image
	}
	r := len(image)
	c := len(image[0])
	queue := [][]int{}
	queue = append(queue, []int{sr, sc})
	image[sr][sc] = newColor
	for i := 0; i < len(queue); i++ {
		cell := queue[i]
		queue = bfs(image, r, c, cell[0]-1, cell[1], oldColor, newColor, queue)
		queue = bfs(image, r, c, cell[0]+1, cell[1], oldColor, newColor, queue)
		queue = bfs(image, r, c, cell[0], cell[1]-1, oldColor, newColor, queue)
		queue = bfs(image, r, c, cell[0], cell[1]+1, oldColor, newColor, queue)
	}
	return image
}

func bfs(image [][]int, r int, c int, sr int, sc int, color int, newColor int, queue [][]int) [][]int {
	if sr >= 0 && sr < r && sc >= 0 && sc < c && image[sr][sc] == color {
		image[sr][sc] = newColor
		queue = append(queue, []int{sr, sc})
	}
	return queue
}

func main() {
	image := [][]int{{1, 1, 1}, {1, 1, 0}, {1, 0, 1}}
	fmt.Println(floodFill(image, 1, 1, 2))
	image2 := [][]int{{1, 1, 1}, {1, 1, 0}, {1, 0, 1}}
	fmt.Println(floodFill2(image2, 1, 1, 2))
}
