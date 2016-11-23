/**
 * Usage:
 * File Name: add_test.go
 * Author: annhe
 * Mail: i@annhe.net
 * Created Time: 2016-11-15 18:02:44
 **/

package simplemath

import "testing"

func TestAdd1(t *testing.T) {
	r := Add(1, 2)
	if r != 3 {
		t.Error("Add(1,2) failed. Got %d, expected 3.", r)
	}
}
