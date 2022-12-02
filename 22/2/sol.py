# AOC2022 day 2 -> https://adventofcode.com/2022/day/2


CONVERSION_CHART_PT1 = {
    "A": "ROCK",
    "B": "PAPER",
    "C": "SCISSORS",

    "X": "ROCK",
    "Y": "PAPER",
    "Z": "SCISSORS",
}
CONVERSION_CHART_PT2 = {
    "A": "ROCK",
    "B": "PAPER",
    "C": "SCISSORS",

    "X": "LOSS",
    "Y": "DRAW",
    "Z": "WIN",
}
SCORE_CHART = {
    "ROCK": 1,
    "PAPER": 2,
    "SCISSORS": 3,

    "LOSS": 0,
    "DRAW": 3,
    "WIN": 6
}
POSSIBLE_HANDS = ["ROCK", "PAPER", "SCISSORS"]


def get_input(file: str) -> list:
    """Parse the input file.

    Parameters:
    file (str): Input filename.

    Returns:
    list: Contains a list for each match.
    """

    with open(file, "r") as f:
        matches = [line.split() for line in f.readlines()]
    return matches

def part1(matches: list) -> int:
    """Calculates the score when both the opponents hand and my hand is known.

    Parameters:
    matches (list): Contains a list for each match.

    Returns:
    int: Total score.
    """

    score = 0
    for opponent, me in matches:
        my_hand, opponents_hand = CONVERSION_CHART_PT1[me], CONVERSION_CHART_PT1[opponent]
        score += SCORE_CHART[my_hand]
        # DRAW
        if my_hand == opponents_hand:
            score += SCORE_CHART["DRAW"]
        # WIN
        elif my_hand == POSSIBLE_HANDS[SCORE_CHART[opponents_hand] % 3]:
            score += SCORE_CHART["WIN"]
    return score

def part2(matches: list) -> int:
    """Calculates the score when the opponents hand and the match result is known.
    
    Parameters:
    matches (list): Contains a list for each match.

    Returns:
    int: Total score.
    """

    score = 0
    for opponent, result in matches:
        match_result, opponents_hand = CONVERSION_CHART_PT2[result], CONVERSION_CHART_PT2[opponent]
        score += SCORE_CHART[match_result]
        # finds what hand I need in order to LOSE
        if match_result == "LOSS":
            my_hand = POSSIBLE_HANDS[(SCORE_CHART[opponents_hand]+1) % 3]
            score += SCORE_CHART[my_hand]
        # finds what hand I need in order to WIN
        elif match_result == "WIN":
            my_hand = POSSIBLE_HANDS[SCORE_CHART[opponents_hand]%3]
            score += SCORE_CHART[my_hand]
        # draw
        else:
            score += SCORE_CHART[opponents_hand]
    return score


if __name__ == "__main__":
    matches = get_input("input.txt")

    score_pt1 = part1(matches)
    score_pt2 = part2(matches)

    print(f"PART 1: {score_pt1}")
    print(f"PART 2: {score_pt2}")