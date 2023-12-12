import parseopt
import strutils
import sequtils
import sets

let p = initOptParser()
let args = p.remainingArgs()
if len(args) != 1:
    echo "File name missing"
    quit()

let fn = args[0]
let f = open(fn)
var data = f.readAll().strip().split('\n')
f.close()

var
    HEIGHT = len(data)
    WIDTH = len(data[0])
    empty_row = toHashSet(toSeq(0..<HEIGHT))
    empty_col = toHashSet(toSeq(0..<WIDTH))
    galaxies: seq[array[2, int]]

for i in 0..<HEIGHT:
    for j in 0..<WIDTH:
        if data[i][j] == '#':
            galaxies.add([i, j])
            empty_row.excl(i)
            empty_col.excl(j)

var
    total: int
    large: int
    mini: int
    maxi: int
    cnt: int

for part in 1..2:
    large = [2, 1000000][part-1]
    total = 0
    for i in 0..<len(galaxies)-1:
        for j in i..<len(galaxies):
            mini = galaxies[i][0]
            maxi = galaxies[j][0]
            cnt = toSeq(mini..maxi).countIt(it in empty_row)
            total += (maxi-mini) + cnt * (large - 1)
            
            mini = min(galaxies[i][1], galaxies[j][1])
            maxi = max(galaxies[i][1], galaxies[j][1])
            cnt = toSeq(mini..maxi).countIt(it in empty_col)
            total += (maxi-mini) + cnt * (large - 1)

    echo "Part ", part, ": ", total
