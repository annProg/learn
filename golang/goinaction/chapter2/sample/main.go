package main

import (
	"log"
	"os"

	_ "sample/matchers"
	"sample/search"
)

func init() {
	log.SetOutput(os.Stdout)
}

func main() {
	search.Run("president")
}
