# AOC2022 day 4 -> https://adventofcode.com/2022/day/4

def get_input(file: str) -> list:
    """Parse the input file.

    Parameters:
    file (str): Input filename.

    Returns:
    list: Contains lists representing pair of ranges.
    """

    with open(file, "r") as f:
        sections = []
        for line in f.readlines():
            first_str, second_str = line.rstrip().split(",")

            # split and convert to int
            first_range = first_str.split("-")
            first_range[0], first_range[1] = int(first_range[0]), int(first_range[1])

            # split and convert to int
            second_range = second_str.split("-")
            second_range[0], second_range[1] = int(second_range[0]), int(second_range[1])

            sections.append([first_range, second_range])
    return sections


def part1(sections: list) -> int:
    """Calculates the amount of pairs where one range is completely contained by the other.
    
    Parameters:
    sections (list): Contains lists representing pair of ranges.

    Returns:
    int: Amount of pairs where one range is completely contained by the other.
    """
    count = 0
    for first, second in sections:
        if second[0] <= first[0] <= second[1] and second[0] <= first[1] <= second[1]:
            count += 1
        elif first[0] <= second[0] <= first[1] and first[0] <= second[1] <= first[1]:
            count += 1
    return count

def part2(sections: list) -> int:
    """Calculates the amount of pairs where the ranges overlap.

    Parameters:
    sections (list): Contains lists representing pair of ranges.

    Returns:
    int: Amount of pairs where the ranges overlap.
    """
    count = 0
    for first, second in sections:
        if second[0] <= first[0] <= second[1] or second[0] <= first[1] <= second[1]:
            count += 1
        elif first[0] <= second[0] <= first[1] or first[0] <= second[1] <= first[1]:
            count += 1
    return count


if __name__ == "__main__":
    sections = get_input("input.txt")

    overlap_count_pt1 = part1(sections)
    overlap_count_pt2 = part2(sections)

    print(f"PART 1: {overlap_count_pt1}")
    print(f"PART 2: {overlap_count_pt2}")