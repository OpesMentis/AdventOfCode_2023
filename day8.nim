import parseopt
import strutils
import tables
import math

let p = initOptParser()
let args = p.remainingArgs()
if len(args) != 1:
    echo "File name missing"
    quit()

let fn = args[0]
let f = open(fn)
let data = f.readAll().strip().split("\n\n")
f.close()

let path = data[0]

var
    nodes: Table[string, array[2, string]]
    init: Table[string, int]
    curr: string
    n: string
    p2 = 1

for line in data[1].split("\n"):
    n = line.substr(0, 2)
    nodes[n] = [line.substr(7, 9), line.substr(12, 14)]
    if n[^1] == 'A':
        init[n] = 0
        curr.add(n)

for n in init.keys:
    curr = n
    while curr[^1] != 'Z':
        curr = if path[init[n] mod len(path)] == 'L': nodes[curr][0] else: nodes[curr][1]
        init[n] += 1
    
    p2 = lcm(p2, init[n])

echo "Part 1: ", init["AAA"]
echo "Part 2: ", p2
