import re
from typing import Generator


def get_line(file: str) -> Generator[list[str], None, None]:
    """Generator reads the file and splits a line into a list of strings. It yields the list.

    Line from file:
    Game 1: 20 green, 3 red, 2 blue; 9 red, 16 blue, 18 green; 6 blue, 19 red, 10 green; 12 red, 19 green, 11 blue

    Yield after split:
    ['Game 1', '20 green', '3 red', '2 blue', '9 red', '16 blue', '18 green', '6 blue', '19 red', '10 green', '12 red', '19 green', '11 blue']
    """
    with open(file, "r") as f:
        for line in f:
            line = line.rstrip("\n") # remove trailing newline.
            # use RegEx to split the line on delimiters: ':' AND ';' AND ','. '\s*' removes optional whitespace.
            line_split = re.split(r"\s*[:;,]\s*", line)
            yield line_split

def sol1(input: str) -> int:
    """Solution to Part 1."""

    # dict with the max count for each color. will use this to check if the game is valid.
    max_count = { "red": 12, "green": 13, "blue": 14 }
    sum = 0
    for line_split in get_line(input):

        # first argument in line_split is the game info -> "Game X".
        # remove the text "Game X" and convert the remaining number to an int.
        gameNum = int(line_split[0].removeprefix("Game "))

        valid = True # use this to mark if the game turns invalid.
        for cubes in line_split[1:]:
            count, color = cubes.split() # split on whitespace to separate the count from the color: "12 red" -> ["12", "red"]
            # if the current count is bigger than the max then the game is impossible
            if max_count[color] < int(count):
                # game is impossible. skip to the next game.
                valid = False
                break

        # if game is valid add gameNum to the sum.
        if valid:
            sum += gameNum

    return sum

def sol2(input: str) -> int:
    """Solution to Part 2."""

    sum = 0
    for line_split in get_line(input):

        color_count = { "red": 0, "blue": 0, "green": 0 }
        set = line_split[1:] # remove the game info, it is not needed for this task.

        for cubes in set:
            count, color = cubes.split() # split on whitespace to separate the count from the color: "12 red" -> ["12", "red"]
            count = int(count) # convert from str to int

            if color_count[color] < count: # update the dict with the highest count for that color.
                color_count[color] = count

        # multiply the counts together
        power = 1
        for count in color_count.values():
            power *= count

        # add the power to the total sum
        sum += power
    return sum

# Only run if this is the main file. This block DOESN'T run if the file is imported.
if __name__ == "__main__":
    # Solution 1
    ans1 = sol1("input.txt")
    print("Answer 1:", ans1)

    # Solution 2
    ans2 = sol2("input.txt")
    print("Answer 2:", ans2)
