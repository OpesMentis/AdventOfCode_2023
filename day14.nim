import parseopt
import strutils

let p = initOptParser()
let args = p.remainingArgs()
if len(args) != 1:
    echo "File name missing"
    quit()

let fn = args[0]
let f = open(fn)
let data = f.readAll().strip().split("\r\n")
f.close()

let
    width = len(data[0])
    height = len(data)

var
    ch: char
    hash: int
    cnt: int
    load: int

for j in 0..<width:
    cnt = 0
    hash = -1
    for i in 0..<height:
        ch = data[i][j]
        if ch == 'O':
            cnt += 1
        
        if i == height-1 or ch == '#':
            for k in 1..cnt:
                load += height-hash-k
            hash = i
            cnt = 0

echo "Part 1: ", load
