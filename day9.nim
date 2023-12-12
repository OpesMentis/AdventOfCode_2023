import parseopt
import strutils
import sequtils

proc get_diffs(hist: seq[int]): seq[int] =
    for i in 0 ..< len(hist)-1:
        result.add(hist[i+1] - hist[i])

let p = initOptParser()
let args = p.remainingArgs()
if len(args) != 1:
    echo "File name missing"
    quit()

let fn = args[0]
let f = open(fn)
var data: seq[seq[int]]
for line in f.readAll().strip().split("\n"):
    data.add(map(line.split(" "), parseInt))

f.close()

var
    diffs: seq[seq[int]]
    tot1: int
    tot2: int

for hist in data:
    diffs = @[hist]
    while not all(diffs[^1], proc (x: int): bool = x == 0):
        diffs.add(get_diffs(diffs[^1]))
    
    for i in countdown(len(diffs)-1, 0):
        if i == len(diffs)-1:
            diffs[i].add(0)
            diffs[i].insert(@[0])
        else:
            diffs[i].add(diffs[i][^1] + diffs[i+1][^1])
            diffs[i].insert(@[diffs[i][0] - diffs[i+1][0]])
    
    tot1 += diffs[0][^1]
    tot2 += diffs[0][0]

echo "Part 1: ", tot1
echo "Part 2: ", tot2
