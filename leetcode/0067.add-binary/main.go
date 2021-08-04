package main

import "fmt"

func addBinary(a string, b string) string {
	aa := []byte(a)
	bb := []byte(b)

	la, lb, L := len(aa), len(bb), 0
	var zero []byte
	if la < lb {
		zero = addZero(lb - la)
		aa = append(zero, aa...)
		L = lb
	} else if la > lb {
		zero = addZero(la - lb)
		bb = append(zero, bb...)
		L = la
	} else {
		L = la
	}

	res := []byte{}
	flag := 0
	var n byte
	for i := L - 1; i >= 0; i-- {
		if aa[i] == '1' && bb[i] == '1' {
			n = '0'
			if flag == 1 {
				n = '1'
			}
			flag = 1
			res = append([]byte{n}, res...)
		} else if aa[i] == '1' || bb[i] == '1' {
			n = '1'
			if flag == 1 {
				flag = 1
				n = '0'
			} else {
				flag = 0
			}
			res = append([]byte{n}, res...)
		} else {
			n = '0'
			if flag == 1 {
				n = '1'
				flag = 0
			}
			res = append([]byte{n}, res...)
		}
	}
	if flag == 1 {
		n = '1'
		res = append([]byte{n}, res...)
	}
	return string(res)
}

func addZero(n int) []byte {
	res := make([]byte, n)
	for i := 0; i < n; i++ {
		res[i] = '0'
	}
	return res
}

func main() {
	fmt.Println(addBinary("1010", "1011"))
}
