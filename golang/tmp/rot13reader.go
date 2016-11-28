package main

import (
	"io"
	"os"
	"strings"
)

type rot13Reader struct {
	r io.Reader
}

func (self rot13Reader) Read(p []byte) (n int, err error) {
	self.r.Read(p)
	leng := len(p)
	for i := 0; i < leng; i++ {
		switch {
		case p[i] >= 'a' && p[i] < 'n':
			fallthrough
		case p[i] >= 'A' && p[i] < 'N':
			p[i] = p[i] + 13
		case p[i] >= 'n' && p[i] <= 'z':
			fallthrough
		case p[i] >= 'N' && p[i] <= 'Z':
			p[i] = p[i] - 13
		}
	}
	return leng, nil
}

func main() {
	s := strings.NewReader("Lbh penpxrq gur pbqr!")
	r := rot13Reader{s}
	io.Copy(os.Stdout, &r)
}
