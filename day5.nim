import parseopt
import sequtils
import strutils

let p = initOptParser()
let args = p.remainingArgs()
if len(args) != 1:
    echo "File name missing"
    quit()

let fn = args[0]
let f = open(fn)
let data = f.readAll().strip().split("\r\n\r\n")
f.close()

var
    seeds1 = map(data[0].split(" ")[1..^1], parseInt)
    seeds2: seq[array[2, int]]
    nseeds2: seq[array[2, int]]
    maps: seq[seq[seq[int]]]
    s: array[2, int]
    found: bool
    mini = -1

for i, s in seeds1:
    if i mod 2 == 1:
        seeds2.add([seeds1[i-1], s])

for i, group in data[1..^1]:
    var grid = newSeq[seq[int]]()
    for line in group.strip().split("\n")[1..^1]:
        grid.add(map(line.strip().split(" "), parseInt))
    
    maps.add(grid)

for m in maps:
    for i, s in seeds1:
        for r in m:
            if s >= r[1] and s < r[1]+r[2]:
                seeds1[i] += r[0] - r[1]
                break

for m in maps:
    nseeds2 = @[]
    while len(seeds2) > 0:
        s = seeds2.pop()
        found = false
        
        if s[1] == 0:
            continue

        for r in m:
            if r[1] <= s[0] and s[0] < r[1] + r[2] and r[1] + r[2] <= s[0] + s[1]:
                nseeds2.add([s[0] + r[0] - r[1], r[1] + r[2] - s[0]])
                seeds2.add([r[1] + r[2], s[0] + s[1] - r[1] - r[2]])
                found = true
                break
            elif s[0] < r[1] and r[1] < s[0] + s[1] and s[0] + s[1] <= r[1] + r[2]:
                nseeds2.add([r[0], s[0] + s[1] - r[1]])
                seeds2.add([s[0], r[1] - s[0]])
                found = true
                break
            elif s[0] <= r[1] and r[1] + r[2] <= s[0] + s[1]:
                nseeds2.add([r[0], r[2]])
                seeds2.add([s[0], r[1] - s[0]])
                seeds2.add([r[1] + r[2], s[0] + s[1] - r[1] - r[2]])
                found = true
                break
            elif r[1] <= s[0] and s[0] + s[1] <= r[1] + r[2]:
                nseeds2.add([s[0] + r[0] - r[1], s[1]])
                found = true
                break
        
        if not found:
            nseeds2.add([s[0], s[1]])
    
    seeds2 = nseeds2

for s in nseeds2:
    if mini == -1 or s[0] < mini:
        mini = s[0]

echo "Part 1: ", min(seeds1)
echo "Part 2: ", mini
