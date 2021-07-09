package main

import "fmt"

func intToRoman(num int) string {
	if num < 1 || num > 3999 {
		return ""
	}
	m := map[int]string{1: "I", 5: "V", 10: "X", 50: "L", 100: "C", 500: "D", 1000: "M"}
	s := ""
	for i := 1000; i > 0; i = i / 10 {
		bit := num / i
		if bit == 0 {
			continue
		}

		one := i
		five := i * 5
		next := i * 10
		if bit < 4 {
			for j := 0; j < bit; j++ {
				s += m[one]
			}
		} else if bit == 4 {
			s += m[one] + m[five]
		} else if bit < 9 {
			s += m[five]
			for j := 5; j < bit; j++ {
				s += m[one]
			}
		} else if bit == 9 {
			s += m[one] + m[next]
		}
		num = num - bit*i
	}
	return s
}

var valueSymbols = []struct {
	value  int
	symbol string
}{
	{1000, "M"},
	{900, "CM"},
	{500, "D"},
	{400, "CD"},
	{100, "C"},
	{90, "XC"},
	{50, "L"},
	{40, "XL"},
	{10, "X"},
	{9, "IX"},
	{5, "V"},
	{4, "IV"},
	{1, "I"},
}

// 官方题解
func intToRoman2(num int) string {
	roman := []byte{}
	for _, vs := range valueSymbols {
		for num >= vs.value {
			num -= vs.value
			roman = append(roman, vs.symbol...)
		}
		if num == 0 {
			break
		}
	}
	return string(roman)
}

func main() {
	fmt.Println(99, intToRoman(99))
	fmt.Println(4, intToRoman(4))
	fmt.Println(1, intToRoman(1))
	fmt.Println(23, intToRoman(23))
	fmt.Println(3999, intToRoman(3999))
	fmt.Println(3999, intToRoman2(3999))
}
