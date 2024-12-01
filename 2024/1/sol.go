package main

import (
	"bufio"
	"fmt"
	"os"
	"slices"
	"strconv"
	"strings"
)

func parseFile(file string) ([]int, []int) {
	f, err := os.Open(file)
	if err != nil {
		panic(fmt.Errorf("Error opening file: %w", err))
	}

	scanner := bufio.NewScanner(f)
	var l1, l2 []int
	for scanner.Scan() {
		line := scanner.Text()
		ss := strings.Fields(line)
		leftNum, _ := strconv.Atoi(ss[0])
		rightNum, _ := strconv.Atoi(ss[1])
		l1 = append(l1, leftNum)
		l2 = append(l2, rightNum)
	}
	slices.Sort(l1)
	slices.Sort(l2)
	return l1, l2
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}

func sumShortestDistance(l1, l2 []int) int {
	sum := 0
	for i := 0; i < len(l1); i++ {
		sum += abs(l1[i] - l2[i])
	}
	return sum
}

func calcSimilarityScore(l1, l2 []int) int {
	sum := 0
	for i := 0; i < len(l1); i++ {
		count := 0
		for _, v := range l2 {
			if v > l1[i] {
				break
			}
			if v == l1[i] {
				count++
			}
		}
		sum += l1[i] * count
	}
	return sum
}

func main() {
	l1, l2 := parseFile("input.txt")
	ans1, ans2 := sumShortestDistance(l1, l2), calcSimilarityScore(l1, l2)
	fmt.Printf("Answer 1: %v\nAnswer 2: %v\n", ans1, ans2)
}
