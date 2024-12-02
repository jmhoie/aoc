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
	reports := parseFile("input.txt")
	safeCount, safeWithDeleteCount := countSafeReports(reports)
	fmt.Printf("Answer 1: %v\nAnswer 2: %v\n", safeCount, safeWithDeleteCount)
}

func countSafeReports(reports [][]int) (int, int) {
	sum, sumWithDelete := 0, 0
	for _, report := range reports {
		if isSafe(report) {
			sum++
		}
		if isSafeWithDelete(report) {
			sumWithDelete++
		}
	}
	return sum, sumWithDelete
}

func isSafe(report []int) bool {
	// make a reversed copy of the original report
	reportReversed := make([]int, len(report))
	copy(reportReversed, report)
	slices.Reverse(reportReversed)

	// check both report and reportReversed
	reportSafety := []bool{true, true}
	for i, r := range [][]int{report, reportReversed} {
		if !slices.IsSorted(r) {
			reportSafety[i] = false
			continue
		}
		for j := 1; j < len(r); j++ {
			diff := r[j] - r[j-1]
			if diff < 1 || diff > 3 {
				reportSafety[i] = false
				break
			}
		}
	}
	return reportSafety[0] != reportSafety[1]
}

func isSafeWithDelete(report []int) bool {
	if isSafe(report) {
		return true
	}

	reportCopy := make([]int, len(report))
	copy(reportCopy, report)

	for i := 0; i < len(reportCopy); i++ {
		if isSafe(removeElemAtIdx(reportCopy, i)) {
			return true
		}
	}
	return false
}

func removeElemAtIdx(s []int, idx int) []int {
	sc := make([]int, len(s))
	copy(sc, s)
	return append(sc[:idx], sc[idx+1:]...)
}

func parseFile(path string) [][]int {
	file, err := os.Open(path)
	if err != nil {
		panic(fmt.Errorf("Error opening file: %w", err))
	}
	defer file.Close()

	reports := make([][]int, 1000)
	i := 0
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		reportStr := strings.Fields(line)

		// convert str values to int
		reportInt := make([]int, len(reportStr))
		for j, v := range reportStr {
			reportInt[j], _ = strconv.Atoi(v)
		}
		reports[i] = reportInt
		i++
	}
	return reports
}
