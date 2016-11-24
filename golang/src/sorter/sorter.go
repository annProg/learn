package main

import "bufio"
import "io"
import "fmt"
import "flag"
import "os"
import "strconv"
import "time"

import "sorter/algorithms/bubblesort"
import "sorter/algorithms/qsort"

var infile *string = flag.String("i", "infile", "待排序数据文件")
var outfile *string = flag.String("o", "outfile", "排序结构输出文件")
var algorithm *string = flag.String("a", "qsort", "排序算法")

func readValues(infile string) (values []int, err error) {
	file, err := os.Open(infile)
	if err != nil {
		fmt.Println("Failed to open the input file", infile)
		return
	}

	defer file.Close()

	br := bufio.NewReader(file)
	values = make([]int, 0)
	for {
		line, isPrefix, err1 := br.ReadLine()

		if err1 != nil {
			if err1 != io.EOF {
				err = err1
			}
			break
		}

		if isPrefix {
			fmt.Println("A too lang line, seems unexpected.")
			return
		}

		str := string(line)
		value, err1 := strconv.Atoi(str)

		if err1 != nil {
			err = err1
			return
		}
		values = append(values, value)
	}
	return
}

func writeValues(values []int, outfile string) error {
	file, err := os.Create(outfile)
	if err != nil {
		fmt.Println("Failed to create the output file", outfile)
		return err
	}

	defer file.Close()

	for _, value := range values {
		str := strconv.Itoa(value)
		file.WriteString(str + "\n")
	}
	return nil
}

func main() {
	flag.Parse()
	if infile != nil {
		fmt.Println("infile=", *infile, "outfile=", *outfile, "algorithm =", *algorithm)
	}

	values, err := readValues(*infile)
	if err == nil {
		t1 := time.Now()
		switch *algorithm {
		case "qsort":
			qsort.QuickSort(values)
		case "bubblesort":
			bubblesort.BubbleSort(values)
		default:
			fmt.Println("Sorting algorithm", *algorithm, "is either unkonw or unsupported.")
		}
		t2 := time.Now()
		fmt.Println(*algorithm, "算法耗时:", t2.Sub(t1))

		writeValues(values, *outfile)
	} else {
		fmt.Println(err)
	}
}
