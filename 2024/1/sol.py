def read_file():
    left_list = []
    right_list = []

    with open("input.txt", "r") as f:
        for line in f.readlines():
            numbers = line.rstrip("\n").split("   ")

            left_str = numbers[0]
            right_str = numbers[1]

            left_num = int(left_str)
            right_num = int(right_str)

            left_list.append(left_num)
            right_list.append(right_num)

    left_list.sort()
    right_list.sort()
    return left_list, right_list

def sum_differanse(left_list, right_list):
    sum = 0
    for i in range(len(left_list)):
        left_num = left_list[i]
        right_num = right_list[i]

        sum += abs(left_num - right_num)

    return sum


lister = read_file()
sum = sum_differanse(lister[0], lister[1])
print(sum)

