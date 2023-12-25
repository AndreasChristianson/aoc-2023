package main

import (
	"bufio"
	"fmt"
	"github.com/AndreasChristianson/aoc-2023/day24/hail2d"
	"github.com/AndreasChristianson/aoc-2023/day24/hail3d"
	"gonum.org/v1/gonum/stat/combin"
	"log"
	"os"
	"os/exec"
	"regexp"
	"strconv"
	"strings"
)

func main() {
	file, err := os.Open(os.Args[1])
	if err != nil {
		panic(err)
	}
	defer func(file *os.File) {
		err := file.Close()
		if err != nil {
			panic(err)
		}
	}(file)

	scanner := bufio.NewScanner(file)
	var lines []string
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
		if err := scanner.Err(); err != nil {
			log.Fatal(err)
		}
	}
	var hailstones []*hail2d.Hail2d
	rx := regexp.MustCompile(`^\s*(?P<x>-?\d+),\s*(?P<y>-?\d+),\s*(?P<z>-?\d+)\s*@\s*(?P<dx>-?\d+),\s*(?P<dy>-?\d+),\s*(?P<dz>-?\d+)$`)
	for _, line := range lines {
		//println(line)
		matches := rx.FindStringSubmatch(line)
		x := toInt(matches[1])
		y := toInt(matches[2])
		z := toInt(matches[3])
		dx := toInt(matches[4])
		dy := toInt(matches[5])
		dz := toInt(matches[6])
		hailstones = append(hailstones, hail2d.FromVectors(x, y, z, dx, dy, dz))
	}
	cs := combin.Combinations(len(hailstones), 2)
	lower := toInt(os.Args[2])
	upper := toInt(os.Args[3])
	//fmt.Printf("bounds: (%f,%f)\n", lower, upper)
	count := 0
	for _, c := range cs {
		x, y := hailstones[c[0]].GetIntersection(hailstones[c[1]])
		dir1 := hailstones[c[0]].Direction(x, y)
		dir2 := hailstones[c[1]].Direction(x, y)
		//fmt.Printf("A: %s\n", hailstones[c[0]].ToString())
		//fmt.Printf("B: %s\n", hailstones[c[1]].ToString())
		//fmt.Printf("(%f,%f), %d %d\n", x, y, dir1, dir2)
		if x < upper && x > lower && y < upper && y > lower && dir2 == 1 && dir1 == 1 {
			count++
		}
	}
	println(count)

	var hailstones3d []*hail3d.Hail3d
	python := "from sympy import *\n\ndx, dy, dz = symbols('dx dy dz')\nx0, y0, z0 = symbols('0x y0 z0')\neqs = []\n"
	for i, line := range lines[0:4] {
		matches := rx.FindStringSubmatch(line)
		x := matches[1]
		y := matches[2]
		z := matches[3]
		dx := matches[4]
		dy := matches[5]
		dz := matches[6]
		hail := hail3d.FromVectors(x, y, z, dx, dy, dz)
		hailstones3d = append(hailstones3d, hail)
		python += hail.ToSympy(i)
		python += fmt.Sprintf("eqs.extend((eq%[1]dx, eq%[1]dy, eq%[1]dz))\n", i)
	}
	python += "print(solve(eqs))\n"

	command := exec.Command("python")

	command.Stdin = strings.NewReader(python)
	command.Stdout = os.Stdout

	err = command.Start()
	if err != nil {
		panic(err)
	}
	err = command.Wait()
	if err != nil {
		panic(err)
	}
	//for _, c := range cs {
	//	par := hailstones3d[c[0]].AreParallel(hailstones3d[c[1]])
	//	//dir1 := hailstones3d[c[0]].Direction(x, y)
	//	//dir2 := hailstones3d[c[1]].Direction(x, y)
	//	if par {
	//		fmt.Printf("par A: %s\n", hailstones3d[c[0]])
	//		fmt.Printf("par B: %s\n", hailstones3d[c[1]])
	//	}
	//	intersection, ok := hailstones3d[c[0]].Intersection(hailstones3d[c[1]])
	//	//dir1 := hailstones3d[c[0]].Direction(x, y)
	//	//dir2 := hailstones3d[c[1]].Direction(x, y)
	//	if ok {
	//		fmt.Println(intersection)
	//		fmt.Printf("int A: %s\n", hailstones3d[c[0]])
	//		fmt.Printf("int B: %s\n", hailstones3d[c[1]])
	//	}
	//}
}

func toInt(str string) float64 {
	x, err := strconv.ParseInt(str, 10, 64)
	if err != nil {
		panic(err)
	}
	return float64(x)
}
