# AOC2022 day 1 -> https://adventofcode.com/2022/day/1 


def get_input(file: str) -> list:
    """Parse the input file.
    
    Parameters:
    file (str): Filename for the input file.

    Returns:
    list: Contains a list of calorie items for each elf.
    """

    nums: list = [[]]
    with open(file, "r") as f:
        for idx, line in enumerate(f.readlines()):
            if line == "\n" and idx > 0:
                nums.append(list())
            else:
                nums[-1].append(int(line.rstrip()))
    return nums

def part1(nums: list) -> int:
    """Finds the highest calorie sum.

    Parameters:
    nums (list): Contains a list of calorie items for each elf.

    Returns:
    int: Highest calorie sum.
    """

    curr_sum, curr_max = 0, 0
    for ns in nums:
        curr_sum = sum(ns)
        if curr_sum > curr_max:
            curr_max = curr_sum
        curr_sum = 0
    return curr_max

def part2(nums: list) -> int:
    """Finds the three highest calorie sums and returns the total amount of calories.
    
    Parameters:
    nums (list): Contains a list of calorie items for each elf.

    Returns:
    int: Total sum of the three highest calorie sums.
    """

    curr_sum = 0
    curr_max = [0, 0, 0]
    for ns in nums:
        curr_max.sort()
        curr_sum = sum(ns)
        for idx, n in enumerate(curr_max):
            if curr_sum > n:
                curr_max[idx] = curr_sum
                curr_sum = 0
                break
    return sum(curr_max)


if __name__ == "__main__":
    nums = get_input("input.txt")

    max_p1 = part1(nums)
    max_p2 = part2(nums)

    print(f"Part 1: {max_p1}")
    print(f"Part 2: {max_p2}")