package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
	"unicode"
)

func sol1() (int, error) {
	file, err := os.Open("input.txt")
	if err != nil {
		fmt.Println("Error opening file:", err)
		return 0, err
	}
	defer file.Close()

	sum := 0
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()

		// Loop through string to find first digit
		for _, r := range line {
			if unicode.IsDigit(r) {
				sum += int(r-'0') * 10
				break
			}
		}
		// "abcdefg" --> [65, 66, 67, 68, 69, 70, 71]
		// Loop in reverse to find last digit
		runes := []rune(line)
		for i := len(runes) - 1; i >= 0; i-- {
			if unicode.IsDigit(runes[i]) {
				sum += int(runes[i] - '0')
				break
			}
		}
	}

	return sum, nil
}

func sol2() (int, error) {
	file, err := os.Open("input.txt")
	if err != nil {
		fmt.Println("Error opening file:", err)
		return 0, err
	}
	defer file.Close()

	wordDigits := map[string]int{
		"zero":  0,
		"one":   1,
		"two":   2,
		"three": 3,
		"four":  4,
		"five":  5,
		"six":   6,
		"seven": 7,
		"eight": 8,
		"nine":  9,
	}

	// use pointer to check if nil
	var left, right *int
	sum := 0
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		for i, r := range line {
			if unicode.IsDigit(r) {
				digit := int(r - '0')
				if left == nil {
					left = &digit
				}
				right = &digit
			} else {
				for word, digit := range wordDigits {
					if strings.HasPrefix(line[i:], word) {
						if left == nil {
							left = &digit
						}
						right = &digit
						// advance loop to skip over the matched word
						i += len(word) - 1
					}
				}
			}
		}

		if left != nil && right != nil {
			sum += *left*10 + *right
			left = nil
			right = nil
			continue
		}
		return 0, fmt.Errorf("Digits not found.")
	}
	return sum, nil
}

func main() {
	// Solution 1
	ans1, err := sol1()
	if err != nil {
		fmt.Println("Error: ", err)
		return
	}
	fmt.Println("Answer 1:", ans1)

	// Solution 2
	ans2, err := sol2()
	if err != nil {
		fmt.Println("Error: ", err)
		return
	}
	fmt.Println("Answer 2:", ans2)
}
