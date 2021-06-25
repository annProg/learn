package main

import (
	"fmt"
	"time"
)

func longestPalindrome(s string) string {
	result := ""
	l := len(s)
	for i := l; i > 0; i-- {
		for left := 0; left+i <= l; left++ {
			if isPalindrome(s, left, left+i-1) {
				return s[left : left+i]
			}
		}
	}
	return result
}

func isPalindrome(s string, left, right int) bool {
	for left < right {
		if s[left] != s[right] {
			return false
		}
		left += 1
		right -= 1
	}
	return true
}

// 动态规划
// 当子串为回文时，字串首尾增加相同字符，仍是回文，构造 len x len 的二维表 dp，值表示从 i 到 j 字串是否是回文，显然当 i==j 时，只有一个字符，是回文
// 当 s[i] != s[j] 时，dp[i][j] = false,不是回文，当 s[i] == s[j]时，分两种情况：
//     当字串长度大于等于2时，如果 j-i<3，即长度为2或3时，是回文
//     如果 j-i >=3, 则是否是回文取绝于其子串是否是回文，即 dp[i][j] = dp[i+1][j-1]
// dp[i][j] 为 true 时，更新 maxLen 和字串开始位置
func longestPalindrome2(s string) string {
	l := len(s)
	if l < 2 {
		return s
	}

	maxLen := 1
	begin := 0
	dp := make([][]bool, l)

	for i := 0; i < l; i++ {
		dp[i] = make([]bool, l)
		dp[i][i] = true
	}

	// L 表示字串长度
	for L := 2; L <= l; L++ {
		for i := 0; i < l; i++ {
			// j - i + 1 = L
			j := L + i - 1
			// 有边界越界，退出
			if j >= l {
				break
			}
			if s[i] != s[j] {
				dp[i][j] = false
			} else {
				// 长度为2或3时，肯定是回文
				if j-i < 3 {
					dp[i][j] = true
				} else {
					dp[i][j] = dp[i+1][j-1]
				}
			}
			// 是回文，且长度大于 maxLen时
			if dp[i][j] && j-i+1 > maxLen {
				maxLen = j - i + 1
				begin = i
			}
		}
	}
	return s[begin : begin+maxLen]
}

func longestPalindrome3(s string) string {
	if s == "" {
		return ""
	}
	start, end := 0, 0
	for i := 0; i < len(s); i++ {
		left1, right1 := expandAroundCenter(s, i, i)
		left2, right2 := expandAroundCenter(s, i, i+1)
		if right1-left1 > end-start {
			start, end = left1, right1
		}
		if right2-left2 > end-start {
			start, end = left2, right2
		}
	}
	return s[start : end+1]
}

func expandAroundCenter(s string, left, right int) (int, int) {
	for ; left >= 0 && right < len(s) && s[left] == s[right]; left, right = left-1, right+1 {
	}
	return left + 1, right - 1
}

func main() {
	s := "abcdefghijklmnopqrstuvwxyzxwvutsrqponmlkjihgfedcba"
	start := time.Now()
	longestPalindrome2(s)
	fmt.Println(time.Since(start))
	start2 := time.Now()
	longestPalindrome(s)
	fmt.Println(time.Since(start2))
	start3 := time.Now()
	longestPalindrome3(s)
	fmt.Println(time.Since(start3))
}
