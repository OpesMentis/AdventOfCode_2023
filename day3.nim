import std/parseopt
import strutils
import tables
import sets

let p = initOptParser()
let args = p.remainingArgs()
if len(args) != 1:
    echo "File name missing"
    quit()

let fn = args[0]
let f = open(fn)
let data = f.readAll().strip().split("\n")
f.close()

proc get_neighbours(i: int, j:int, height: int, width: int): seq[array[2, int]] =
    const dirs = [-1, 0, 1]

    for di in dirs:
        if i+di<0 or i+di>=height:
            continue

        for dj in dirs:
            if j+dj<0 or j+dj>=width:
                continue

            result.add([i+di, j+dj])

const nb = "0123456789"

let
    height = len(data)
    width = len(data[0])

var
    symb_adj: bool
    gears: Table[array[2, int], seq[int]]
    l_stars: HashSet[array[2, int]]
    curr_nb: string
    real_nb: int
    sum1: int
    sum2: int
    ch: char
    ii: int
    jj: int

for i in 0 ..< height:
    for j in 0 ..< width:
        if data[i][j] in nb:
            curr_nb &= data[i][j]

            for coords in get_neighbours(i, j, height, width):
                ii = coords[0]
                jj = coords[1]
                ch = data[ii][jj]
                if ch notin nb and ch != '.':
                    symb_adj = true

                    if ch == '*':
                        l_stars.incl([ii, jj])
        
        if (data[i][j] notin nb or j == width-1) and len(curr_nb) > 0:
            real_nb = parseInt(curr_nb)
            sum1 += (if symb_adj: real_nb else: 0)
            for coords in l_stars.items:
                if gears.hasKey(coords):
                    gears[coords].add(real_nb)
                else:
                    gears[coords] = @[real_nb]
            l_stars.clear()

            curr_nb = ""
            symb_adj = false

echo "Part 1: ", sum1

for star in gears.keys:
    if len(gears[star]) == 2:
        sum2 += gears[star][0] * gears[star][1]

echo "Part 2: ", sum2
