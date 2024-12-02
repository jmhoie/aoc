package main

import (
	"bufio"
	"fmt"
	"os"
	"slices"
	"strconv"
	"strings"
)

func main() {
	s1, s2 := parseFile("input.txt")
	totalDistance, similarityScore := sumShortestDistance(s1, s2), calcSimilarityScore(s1, s2)
	fmt.Printf("Answer 1: %v\nAnswer 2: %v\n", totalDistance, similarityScore)
}

func sumShortestDistance(s1, s2 []int) int {
	sum := 0
	for i := 0; i < len(s1); i++ {
		sum += abs(s1[i] - s2[i])
	}
	return sum
}

func calcSimilarityScore(s1, s2 []int) int {
	sum := 0
	for i := 0; i < len(s1); i++ {
		count := 0
		for _, v := range s2 {
			if v > s1[i] {
				break
			}
			if v == s1[i] {
				count++
			}
		}
		sum += s1[i] * count
	}
	return sum
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}

func parseFile(path string) ([]int, []int) {
	file, err := os.Open(path)
	if err != nil {
		panic(fmt.Errorf("Error opening file: %w", err))
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	var s1, s2 []int
	for scanner.Scan() {
		line := scanner.Text()
		ss := strings.Fields(line)
		leftNum, _ := strconv.Atoi(ss[0])
		rightNum, _ := strconv.Atoi(ss[1])
		s1 = append(s1, leftNum)
		s2 = append(s2, rightNum)
	}
	slices.Sort(s1)
	slices.Sort(s2)
	return s1, s2
}
