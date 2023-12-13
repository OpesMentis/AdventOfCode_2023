import parseopt
import strutils
import math

proc transpose(grid: seq[string]): seq[string] =
    let width = len(grid[0])

    for j in 0..<width:
        result.add("")
    
    for line in grid:
        for j, ch in line:
            result[j] &= ch

proc look_for_mirrors(pattern: seq[string]): seq[int] =
    let height = len(pattern)
    let width = len(pattern[0])

    var mini: int
    var ko: bool
    for i in 0..<height-1:
        ko = false
        mini = min(i+1, height-i-1)
        for j in 1..mini:
            if pattern[i-j+1] != pattern[i+j]:
                ko = true
                break
        if not ko:
            result.add(100*(i+1))
    
    let tpattern = transpose(pattern)
    for i in 0..<width-1:
        ko = false
        mini = min(i+1, width-i-1)
        for j in 1..mini:
            if tpattern[i-j+1] != tpattern[i+j]:
                ko = true
                break
        if not ko:
            result.add(i+1)

let p = initOptParser()
let args = p.remainingArgs()
if len(args) != 1:
    echo "File name missing"
    quit()

let fn = args[0]
let f = open(fn)
let data = f.readAll().strip().split("\r\n\r\n")
f.close()

var pattern: seq[string]
var total: int
for grid in data:
    pattern = grid.split("\r\n")
    total += sum(look_for_mirrors(pattern))

echo "Part 1: ", total
