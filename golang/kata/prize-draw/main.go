package main

import (
	"fmt"
	"strings"
)

func charRank(ch byte) int {
	var rank int
	if ch < 97 {
		rank = int(ch) - 64
	} else {
		rank = int(ch) - 96
	}
	return rank
}

func NthRank(st string, we []int, n int) string {
	// your code
	aSt := strings.Split(st, ",")
	aMap := make(map[string]int)
	aRanks := []int{}
	for k, v := range aSt {
		som2 := len(v)
		for _, c := range []byte(v) {
			som2 = som2 + charRank(c)
		}
		som2 = som2 * we[k]
		aMap[v] = som2
		aRanks = append(aRanks, som2)
	}

	for i, _ := range aRanks {
		for j := i + 1; j < len(aRanks); j++ {
			if aRanks[i] < aRanks[j] {
				tmp := aRanks[i]
				aRanks[i] = aRanks[j]
				aRanks[j] = tmp
			}
		}
	}
	fmt.Println(aMap)
	pick := aRanks[n-1]
	sPick := ""
	for k, v := range aMap {
		if pick == v {
			if sPick != "" {
				f1 := int([]byte(sPick)[0])
				f2 := int([]byte(k)[0])
				if f1 < 97 {
					f1 = f1 + 32
				}
				if f2 < 97 {
					f2 = f2 + 32
				}
				if f1 < f2 {
					sPick = k
				}
			} else {
				sPick = k
			}
		}
	}
	return sPick
}

func main() {
	fmt.Println(NthRank("Addison,Jayden,Sofia,Michael,Andrew,Lily,Benjamin", []int{4, 2, 1, 4, 3, 1, 2}, 4))
	fmt.Println(NthRank("Elijah,Chloe,Elizabeth,Matthew,Natalie,Jayden", []int{1, 3, 5, 5, 3, 6}, 2))
}
