from typing import Generator


def get_line(file: str) -> Generator[str, None, None]:
    """Generator reads file and yields one line at a time."""
    with open(file, "r") as f:
        for line in f:
            yield line

def sol1(input: str) -> int:
    """Solution for Part 1."""
    sum = 0
    for line in get_line(input): # loop over each line of the file
        for char in line: # loop over each character in the string
            if char.isdigit():
                sum += int(char)*10
                break
        for char in reversed(line): # reverse the string and loop
            if char.isdigit():
                sum += int(char)
                break
    return sum

def sol2(input: str) -> int:
    """Solution for Part 2."""
    word_to_digit = { # dictionary that maps the word to the value: zero -> 0
        "zero": 0,
        "one": 1,
        "two": 2,
        "three": 3,
        "four": 4,
        "five": 5,
        "six": 6,
        "seven": 7,
        "eight": 8,
        "nine": 9
    }
    sum = 0
    for line in get_line(input):
        left, right = 0, 0
        iter_str = enumerate(line) # allows me to manually advance the loop. enumerate() zips index with character -> [(0, 'a'), (1, 'b'), ...]
        for idx, char in iter_str:
            if char.isdigit(): # if the character is an ascii digit e.g. '1'
                if not left:
                    left = int(char)
                right = int(char)
            else:
                for word, value in word_to_digit.items(): # iterate through dict to check for word match
                    if line[idx:].startswith(word): # check if the string has a word prefix e.g. 'one'
                        if not left:
                            left = value
                        right = value
                        [next(iter_str) for _ in range(len(word)-2)] # advance the loop past the word
        sum += left*10 + right

    return sum


def sol2_basic(input: str) -> int:
    """Solution for Part 2 without the fancy-schmancy iterable. ( kanskje mer nyttig :) )"""
    word_to_digit = { # dictionary that maps the word to the value: zero -> 0
        "zero": 0,
        "one": 1,
        "two": 2,
        "three": 3,
        "four": 4,
        "five": 5,
        "six": 6,
        "seven": 7,
        "eight": 8,
        "nine": 9
    }
    sum = 0
    for line in get_line(input):
        left, right = 0, 0
        for idx, char in enumerate(line): # enumerate() zips index with character -> [a, b, c] becomes [(0, 'a'), (1, 'b'), (2, 'c')]
            if char.isdigit(): # if the character is an ascii digit e.g. '1'
                if not left:
                    left = int(char)
                right = int(char)
            else:
                for word, value in word_to_digit.items(): # iterate through dict to check for word match
                    # line[idx:] start the string at `idx` -> line = 'abcdefg' -> line[2:] gives 'cdefg' (skipped 'a' and 'b')
                    if line[idx:].startswith(word): # check if the string starts with (i.e. has the prefix) word
                        if not left:
                            left = value
                        right = value
        sum += left*10 + right

    return sum

# Only run if this is the main file. This block DOESN'T run if the file is imported.
if __name__ == "__main__":
    # Solution 1
    ans1 = sol1("input.txt")
    print("Answer 1:", ans1)

    # Solution 2
    ans2 = sol2("input.txt")
    print("Answer 2:", ans2)

    # Solution 2_basic
    ans2_basic = sol2_basic("input.txt")
    print("Answer 2_basic:", ans2_basic)
