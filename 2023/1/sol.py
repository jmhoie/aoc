from typing import Generator


def get_line(file: str) -> Generator[str, None, None]:
    """Generator reads file and yields one line at a time."""
    with open(file, "r") as f:
        for line in f:
            yield line

def sol1(input: str) -> int:
    sum = 0
    for line in get_line(input):
        for char in line:
            if char.isdigit():
                sum += int(char)*10
                break
        for char in reversed(line):
            if char.isdigit():
                sum += int(char)
                break
    return sum

def sol2(input: str) -> int:
    word_to_digit = {
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
        iter_str = enumerate(line) # allows me to manually advance the loop
        for idx, char in iter_str:
            if char.isdigit(): # if the character is an ascii digit e.g. '1'
                if not left:
                    left = int(char)
                right = int(char)
            else:
                for word, value in word_to_digit.items(): # iterate through dict to check for word match
                    if line[idx:].startswith(word): # check for word prefix e.g. 'one'
                        if not left:
                            left = value
                        right = value
                        [next(iter_str) for _ in range(len(word)-2)] # advance the loop past the word
        sum += left*10 + right

    return sum

if __name__ == "__main__":
    # Solution 1
    ans1 = sol1("input.txt")
    print("Answer 1:", ans1)

    # Solution 2
    ans2 = sol2("input.txt")
    print("Answer 2:", ans2)
