from aocd.models import Puzzle

# data = """1x1x10
# """
# dimensions_list = data.splitlines()

puzzle = Puzzle(year=2015, day=2)
dimensions_list = puzzle.input_data.splitlines()

wrapping_paper = 0
ribbon = 0

for dimensions_set in dimensions_list:
    dimensions = list(map(int, dimensions_set.split("x")))
    areas = []
    perimeters = []
    volume = 1

    for index, dimension in enumerate(dimensions):
        volume *= dimension
        for i in range(index+1, len(dimensions)):
            area = dimension*dimensions[i]
            areas.append(area)
            perimeter = 2*dimension + 2*dimensions[i]
            perimeters.append(perimeter)

    smallest_area = min(areas)
    smallest_perimeter = min(perimeters)
    wrapping_paper += smallest_area
    ribbon += smallest_perimeter + volume

    for area in areas:
        wrapping_paper += 2*area

print("Part 1: " + str(wrapping_paper))
print("Part 2: " + str(ribbon))
puzzle.answer_a = wrapping_paper
puzzle.answer_b = ribbon
    
    
            
