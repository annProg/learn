package main

import "fmt"

func myAtoi(s string) int {
	stat := "start"
	neg := 1
	result := 0
	min := 1 << 31
	max := 1<<31 - 1

	for i := 0; i < len(s); i++ {
		if s[i] == ' ' {
			if stat != "start" {
				stat = "end"
			}
		} else if s[i] == '+' {
			if stat != "start" {
				stat = "end"
			} else {
				stat = "signed"
			}
		} else if s[i] == '-' {
			if stat != "start" {
				stat = "end"
			} else {
				neg = -1
				stat = "signed"
			}
		} else if s[i] >= 48 && s[i] <= 57 {
			if stat != "start" && stat != "signed" && stat != "in_number" {
				stat = "end"
			} else {
				stat = "in_number"
				if neg == 1 && (max-int(s[i]-48))/10 < result {
					return max
				}
				if neg == -1 && (min-int(s[i]-48))/10 < result {
					return -min
				}
				result = result*10 + int(s[i]-48)
			}
		} else {
			stat = "end"
		}
		if stat == "end" {
			break
		}
	}
	return result * neg
}

func main() {
	fmt.Println(myAtoi(" -42"))
	fmt.Println(myAtoi("42"))
	fmt.Println(myAtoi("-91283472332"))
	fmt.Println(myAtoi("00000-42a1234"))
	fmt.Println(myAtoi("-+12"))
	fmt.Println(myAtoi(" "))
	fmt.Println(myAtoi("9223372036854775808"))
	fmt.Println(myAtoi("2147483646"))
}
