import parseopt
import strutils
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

let
    HEIGHT = len(data)
    WIDTH = len(data[0])

var
    i: int
    j: int
    s_pos = toHashSet("|-LJ7F")
    path: seq[array[2, int]]
    found_s = false
    last: array[2, int]

for ii in 0..<HEIGHT:
    if 'S' in data[ii]:
        i = ii
        j = data[i].find('S')

path.add([i, j])
while len(path) == 1 or data[i][j] != 'S':
    if data[i][j] == 'S':
        if i > 0 and data[i-1][j] in "|7F":
            s_pos = s_pos * toHashSet("|LJ")
            i -= (if found_s: 1 else: 0)
            found_s = true
        if i < HEIGHT-1 and data[i+1][j] in "|LJ":
            s_pos = s_pos * toHashSet("|7F")
            i += (if found_s: 1 else: 0)
            found_s = true
        if j > 0 and data[i][j-1] in "-LF":
            s_pos = s_pos * toHashSet("-J7")
            j -= (if found_s: 1 else: 0)
            found_s = true
        if j < WIDTH-1 and data[i][j+1] in "-J7":
            s_pos = s_pos * toHashSet("-LF")
            j += (if found_s: 1 else: 0)
            found_s = true
        
        continue
    
    last = path[^1]
    path.add([i, j])
    if data[i][j] in "|LJ" and last[0] != i-1:
        i -= 1
    elif data[i][j] in "|F7" and last[0] != i+1:
        i += 1
    elif data[i][j] in "-J7" and last[1] != j-1:
        j -= 1
    else:
        j += 1

let loop = toHashSet(path)
var
    in_loop: int
    flag: bool

data[i][j] = s_pos.pop
for i in 0..<HEIGHT:
    flag = false
    for j in 0..<WIDTH:
        if [i,j] in loop and data[i][j] in "JL|":
            flag = not flag

        elif [i,j] notin loop and flag:
            in_loop += 1

echo "Part 1: ", len(path) div 2
echo "Part 2: ", in_loop
