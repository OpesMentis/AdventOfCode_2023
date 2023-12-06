import parseopt
import sequtils
import strutils
import math

proc countWays(time: float, dist: float): int =
    let delta = time^2 - 4*dist
    let rdelta = sqrt(float(delta))

    let t1 = int(floor((time - rdelta) / 2.0))
    let t2 = int(ceil((time + rdelta) / 2.0))

    return t2 - t1 - 1

let p = initOptParser()
let args = p.remainingArgs()
if len(args) != 1:
    echo "File name missing"
    quit()

let fn = args[0]
let f = open(fn)
let data = f.readAll().strip().split("\n")
f.close()

let
    time1 = map(data[0].splitWhitespace()[1..^1], parseFloat)
    dist1 = map(data[1].splitWhitespace()[1..^1], parseFloat)

let
    time2 = parseFloat(data[0].splitWhitespace()[1..^1].join(""))
    dist2 = parseFloat(data[1].splitWhitespace()[1..^1].join(""))

var prod = 1

for i in 0 ..< len(time1):
    prod *= countWays(time1[i], dist1[i])

echo "Part 1: ", prod
echo "Part 2: ", countWays(time2, dist2)
