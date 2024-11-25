#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define INPUT_FILE "input.txt"
#define MAX_LINE_LENGTH 10

int sol1() {
	FILE *file = fopen(INPUT_FILE, "r");
	if (file == NULL) {
		perror("Error opening file");
		return 0;
	}

	char buf[MAX_LINE_LENGTH];
	int l, w, h; // paper length, width, height
	int sum = 0;
	while (fgets(buf, MAX_LINE_LENGTH, file) != NULL) {

		// using strtok() to split the string on 'x' and return the results. it advances one token each time it's called.
		char *tok = strtok(buf, "x"); // this will return the first str, i.e. paper length.
		l = atoi(tok); // convert from str to int.

		tok = strtok(NULL, "x"); // returns second str, i.e. paper width.
		w = atoi(tok);

		tok = strtok(NULL, "x"); // returns third str, i.e. paper height.
		h = atoi(tok);

		// find smallest side.
		int min, second_min;
		if (l <= h && l <= w) { // if 'l' is the smallest.
			min = l;
			second_min = (h <= w) ? h : w; // '?' -> ternary operator. returns whatever is smallest of 'h' and 'w'.
		} else if (h <= l && h <= w) { // if 'h' is the smallest.
			min = h;
			second_min = (l <= w) ? l : w;
		} else { // if 'w' is the smallest.
			min = w;
			second_min = (l <= h) ? l : h;
		}

		sum += (2*l*w + 2*w*h + 2*h*l) + min*second_min;
	}
	return sum;
}

int sol2() {
	FILE *file = fopen(INPUT_FILE, "r");
	if (file == NULL) {
		perror("Error opening file");
		return 0;
	}

	char buf[MAX_LINE_LENGTH];
	int l, w, h;
	int sum = 0;
	while (fgets(buf, MAX_LINE_LENGTH, file) != NULL) {
		// tokenize string on delim "x"
		char *tok = strtok(buf, "x");
		l = atoi(tok); // convert from str to int
		tok = strtok(NULL, "x");
		w = atoi(tok);
		tok = strtok(NULL, "x");
		h = atoi(tok);

		// find smallest side
		int min, second_min;
		if (l <= h && l <= w) {
			min = l;
			second_min = (h <= w) ? h : w; // '?' -> ternary operator
		} else if (h <= l && h <= w) {
			min = h;
			second_min = (l <= w) ? l : w;
		} else {
			min = w;
			second_min = (l <= h) ? l : h;
		}

		sum += (min*2 + second_min*2) + l*w*h;
	}
	return sum;
}

int main() {
	// Solution 1
	int ans1 = sol1();
	printf("Answer 1: %d\n", ans1);

	// Solution 2
	int ans2 = sol2();
	printf("Answer 2: %d\n", ans2);

	return 0;
}
