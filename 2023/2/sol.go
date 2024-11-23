package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func sol1(input string) (int, error) {
	file, err := os.Open(input)
	if err != nil {
		return 0, err
	}
	defer file.Close()

	sum := 0
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()

		// string split at ':' AND ';' AND ','
		ss := strings.FieldsFunc(line, func(r rune) bool {
			if r == ':' || r == ';' || r == ',' {
				return true
			}
			return false
		})

		gameNum, err := strconv.Atoi(strings.Fields(ss[0])[1])
		if err != nil {
			return 0, fmt.Errorf("Cannot parse Game number: %s", err)
		}

		maxCount := map[string]int{"red": 12, "green": 13, "blue": 14}
		valid := true
		for _, cubes := range ss[1:] { // ignore first element -> "Game X: "
			set := strings.Fields(cubes)

			count, err := strconv.Atoi(set[0])
			if err != nil {
				return 0, fmt.Errorf("Parsing count: %s", err)
			}
			color := set[1]
			if maxCount[color] < count {
				valid = false
				break
			}

		}
		if valid {
			sum += gameNum
		}
	}

	return sum, nil
}

func sol2(input string) (int, error) {
	file, err := os.Open(input)
	if err != nil {
		return 0, err
	}
	defer file.Close()

	sum := 0
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()

		// string split at ':' AND ';' AND ','
		ss := strings.FieldsFunc(line, func(r rune) bool {
			if r == ':' || r == ';' || r == ',' {
				return true
			}
			return false
		})
		minCount := map[string]int{"red": 1, "green": 1, "blue": 1}
		for _, cubes := range ss[1:] { // ignore first element -> "Game X: "
			set := strings.Fields(cubes)

			count, err := strconv.Atoi(set[0])
			if err != nil {
				return 0, fmt.Errorf("Parsing count: %s", err)
			}
			color := set[1]
			if minCount[color] < count {
				minCount[color] = count
			}
		}
		pwr := 1
		for _, v := range minCount {
			pwr *= v
		}
		sum += pwr
	}
	return sum, nil
}

func main() {
	// Solution 1
	ans1, err := sol1("input.txt")
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println("Answer 1:", ans1)

	// Solution 2
	ans2, err := sol2("input.txt")
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println("Answer 2:", ans2)
}
