from aocd.models import Puzzle

puzzle = Puzzle(year=2015, day=1)

floor = 0
for character in puzzle.input_data:
    if character == "(":
        floor +=1 
    elif character == ")":
        floor -= 1
        
part_a_answer = str(floor)
print("Part 1: " + part_a_answer)
puzzle.answer_a = part_a_answer

floor = 0
position = 0
for character in puzzle.input_data:
    position += 1
    if character == "(":
        floor +=1 
    elif character == ")":
        floor -= 1
        if floor < 0:
            break

part_b_answer = str(position)
print("Part 1: " + part_b_answer)
puzzle.answer_b = part_b_answer