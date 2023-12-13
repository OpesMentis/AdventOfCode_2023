import parseopt
import strutils

proc transpose(grid: seq[string]): seq[string] =
    for j in 0..<len(grid[0]):
        result.add("")
    
    for line in grid:
        for j, ch in line:
            result[j] &= ch

proc diff_string(ch1: string, ch2: string): int =
    assert len(ch1) == len(ch2)
    for i in 0..<len(ch1):
        if ch1[i] != ch2[i]:
            result += 1

let p = initOptParser()
let args = p.remainingArgs()
if len(args) != 1:
    echo "File name missing"
    quit()

let fn = args[0]
let f = open(fn)
let data = f.readAll().strip().split("\n\n")
f.close()

var 
    pattern: seq[string]
    result: array[2, int]
    height: int
    width: int
    mini: int
    diff: int

for grid in data:
    pattern = grid.split('\n')

    height = len(pattern)
    width = len(pattern[0])

    for i in 0..<height-1:
        diff = 0
        mini = min(i+1, height-i-1)
        for j in 1..mini:
            diff += diff_string(pattern[i-j+1], pattern[i+j])
        
        if diff == 0:
            result[0] += 100*(i+1)
        elif diff == 1:
            result[1] += 100*(i+1)
    
    pattern = transpose(pattern)
    for i in 0..<width-1:
        diff = 0
        mini = min(i+1, width-i-1)
        for j in 1..mini:
            diff += diff_string(pattern[i-j+1], pattern[i+j])
        
        if diff == 0:
            result[0] += i+1
        elif diff == 1:
            result[1] += i+1

echo "Part 1: ", result[0]
echo "Part 2: ", result[1]
