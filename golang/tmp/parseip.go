package main

import (
	"fmt"
	"net"
	"strings"
)

func validIp(ip string) bool {
	ips := strings.Split(ip, ".")
	if len(ips) != 4 {
		fmt.Println("非4段")
		return false
	}
	for _, part := range ips {
		chs := []byte(part)
		L := len(chs)
		if L == 0 || L > 3 {
			fmt.Println("L==0||L>3")
			return false
		}
		if L > 1 && chs[0]-'0' == 0 {
			fmt.Println("0开头")
			return false
		}
		val := 0
		for i := 0; i < L; i++ {
			fmt.Println(chs[i] - '0')
			if chs[i]-'0' > 10 || chs[i]-'0' < 0 {
				fmt.Println("有非数字")
				return false
			}
			val = 10*val + int(chs[i]-'0')
		}
		if val > 255 {
			fmt.Printf("%d 大于255", val)
			return false
		}
	}
	return true
}

func check(ip string) bool {
	address := net.ParseIP(ip)
	if address == nil && validIp(ip) {
		return false
	}
	return true
}

func main() {
	fmt.Println(check("192.168.1.11"))
}
