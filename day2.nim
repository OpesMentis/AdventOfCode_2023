import std/parseopt
import strutils
import tables

let p = initOptParser()
let args = p.remainingArgs()
if len(args) != 1:
    echo "File name missing"
    quit()

let fn = args[0]
let f = open(fn)
let data = f.readAll().strip().split("\n")
f.close()

var
    i: int
    games: seq[seq[string]]
    max_cols = initTable[string, int]()
    cubes: seq[string]
    pair: seq[string]
    qty: int
    col: string
    sum1 = 0
    sum2 = 0

for line in data:
    i = 0
    while line[i] != ':':
        i += 1
    
    games.add(line.substr(i+2).split("; "))

i = 0
for sets in games:
    i += 1
    max_cols = {"blue": 0, "red": 0, "green": 0}.toTable
    for draw in sets:
        cubes = draw.split(", ")
        for cube in cubes:
            pair = cube.split(" ")
            qty = parseInt(pair[0])
            col = pair[1]

            if max_cols[col] < qty:
                max_cols[col] = qty
    
    if max_cols["red"] <= 12 and max_cols["green"] <= 13 and max_cols["blue"] <= 14:
        sum1 += i
    
    sum2 += max_cols["red"] * max_cols["green"] * max_cols["blue"]

echo "Part 1: ", sum1
echo "Part 2: ", sum2
