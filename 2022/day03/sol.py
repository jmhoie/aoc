# AOC2022 day 3 -> https://adventofcode.com/2022/day/3

def get_input(file: str) -> list:
    """Parse the input file.

    Parameters:
    file (str): Input filename.

    Returns:
    list: Contains strings representing items in a backpack.
    """

    with open(file, "r") as f:
        backpacks = [line.strip() for line in f.readlines()]
    return backpacks

def part1(backpacks: list) -> int:
    """Calculates the priority sum of duplicate items in both compartments.

   Parameters:
   backpacks (list): Contains strings representing items in a backpack. 

   Returns:
   int: Sum of the priority of duplicate items.
    """
    priority_sum = 0
    for backpack in backpacks:
        compartment1, compartment2 = backpack[:(len(backpack)//2)], backpack[(len(backpack)//2):]
        dups = []
        for item in compartment1:
            if item in compartment2 and item not in dups:
                dups.append(item)
                if item.isupper():
                    priority_sum += ord(item)-38
                else:
                    priority_sum += ord(item)-96
    return priority_sum

def part2(backpacks: list) -> int:
    """Calculates the priority sum of the badge for each 3-backpack group.

   Parameters:
   backpacks (list): Contains strings representing items in a backpack. 

   Returns:
   int: Sum of the priority of 3-backpack badges.
    """
    priority_sum = 0
    for i in range(0, len(backpacks), 3):
        backpack1 = sorted(backpacks[i])
        backpack2 = sorted(backpacks[i+1])
        backpack3 = sorted(backpacks[i+2])

        for item in backpack1:
            if item in backpack2 and item in backpack3:
                if item.isupper():
                    priority_sum += ord(item)-38
                else:
                    priority_sum += ord(item)-96
                break
    return priority_sum

if __name__ == "__main__":
    backpacks = get_input("input.txt")

    priority_sum_pt1 = part1(backpacks)
    priority_sum_pt2 = part2(backpacks)

    print(f"PART 1: {priority_sum_pt1}")
    print(f"PART 2: {priority_sum_pt2}")