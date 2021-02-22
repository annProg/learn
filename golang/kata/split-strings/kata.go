package kata

import (
	"strings"
)

func Solution(str string) []string {
	a := strings.Split(str, "")
	ret := []string{}
	for k, v := range a {
		if k%2 == 0 {
			ret = append(ret, v)
		} else {
			l := len(ret) - 1
			ret[l] = ret[l] + v
		}
	}
	l := len(ret) - 1
	if len(a)%2 != 0 {
		ret[l] = ret[l] + "_"
	}
	return ret
}
