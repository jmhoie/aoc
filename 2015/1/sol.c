#include <stdint.h>
#include <stdio.h>
#include <string.h>

#define INPUT_FILE "input.txt"
#define MAX_LINE_LENGTH 1024

int sol1() {
	FILE *file = fopen(INPUT_FILE, "r");
	if (file == NULL) {
		perror("Error opening file");
		return 0;
	}
	int32_t sum = 0;
	char buf[MAX_LINE_LENGTH];
	while(fgets(buf, MAX_LINE_LENGTH, file) != NULL) {
		for (int i=0; i<strlen(buf); ++i) {
			if (buf[i] == '(') {
				sum += 1;
			} else if (buf[i] == ')') {
				sum -= 1;	
			}
		}
	}
	return sum;
}

int sol2() {
	FILE *file = fopen(INPUT_FILE, "r");
	if (file == NULL) {
		perror("Error opening file");
		return 0;
	}

	int sum = 0;
	int parenthesis_count = 0;
	char buf[MAX_LINE_LENGTH];
	while(fgets(buf, MAX_LINE_LENGTH, file) != NULL) {
		for (int i=0; i<strlen(buf); ++i) {
			if (buf[i] == '(') {
				sum += 1;
			} else if (buf[i] == ')') {
				sum -= 1;
			}
			++parenthesis_count;
			
			if (sum < 0) return parenthesis_count;
		}
	}
	return 0;
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
