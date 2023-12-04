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
let data = f.readAll().strip().split("\n")
f.close()

var
    card: seq[string]
    occurences = newSeqWith(len(data), 0)
    score1: int
    score2: int
    total1: int
    total2: int

for i, line in data:
    occurences[i] += 1
    score1 = 0
    score2 = 0
    card = line.split(":")[1].split("|")

    for nb in card[1].splitWhitespace():
        if nb in card[0].splitWhitespace():
            score1 = if score1 < 1: 1 else: 2*score1
            score2 += 1

    for j in 1 .. score2:
        occurences[i+j] += 1 * occurences[i]

    total1 += score1
    total2 += occurences[i]

echo "Part 1: ", total1
echo "Part 2: ", total2
