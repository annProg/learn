package main

import "fmt"

func merge(nums1 []int, m int, nums2 []int, n int) {
	r := []int{}
	n1 := nums1[:m]
	n2 := nums2[:n]
	for len(n1) > 0 && len(n2) > 0 {
		if n1[0] < n2[0] {
			r = append(r, n1[0])
			n1 = n1[1:]
		} else {
			r = append(r, n2[0])
			n2 = n2[1:]
		}
	}

	for len(n1) > 0 {
		r = append(r, n1[0])
		n1 = n1[1:]
	}

	for len(n2) > 0 {
		r = append(r, n2[0])
		n2 = n2[1:]
	}

	for i := 0; i < len(nums1); i++ {
		nums1[i] = r[i]
	}
}

func main() {
	nums1 := []int{1, 2, 3, 0, 0, 0}
	merge(nums1, 3, []int{2, 5, 6}, 3)
	fmt.Println(nums1)
}
