import parseopt
import strutils
import tables
import math
import algorithm

proc eval_hand(hand: string, part: int): int =
    const kinds = ["23456789TJQKA", "J23456789TQKA"]
    const pow13_5 = 13^5

    let cards = hand.toCountTable()
    let lg = len(cards)
    let max_occ = cards.largest()[1]

    for c in hand:
        result *= 13
        result += kinds[part-1].find(c)

    if part == 1 or 'J' notin cards:
        if lg == 1:
            result += 6 * pow13_5
        elif lg == 2 and max_occ == 4:
            result += 5 * pow13_5
        elif lg == 2:
            result += 4 * pow13_5
        elif lg == 3 and max_occ == 3:
            result += 3 * pow13_5
        elif lg == 3:
            result += 2 * pow13_5
        elif lg == 4:
            result += pow13_5
        
        return result

    if lg <= 2:
        result += 6 * pow13_5
    elif lg == 3 and cards['J'] == 1 and max_occ == 2:
        result += 4 * pow13_5
    elif lg == 3:
        result += 5 * pow13_5
    elif lg == 4:
        result += 3 * pow13_5
    else:
        result += pow13_5
    
    return result

let p = initOptParser()
let args = p.remainingArgs()
if len(args) != 1:
    echo "File name missing"
    quit()

let fn = args[0]
let f = open(fn)
let data = f.readAll().strip().split("\n")
f.close()

var bids: Table[string, int]
var vals1: OrderedTable[string, int]
var vals2: OrderedTable[string, int]
var info: seq[string]
var hand: string
var score: int

for line in data:
    info = line.strip().split(" ")
    hand = info[0]

    bids[hand] = parseInt(info[1])
    vals1[hand] = eval_hand(hand, 1)
    vals2[hand] = eval_hand(hand, 2)

vals1.sort(proc (x, y: (string, int)): int = cmp(x[1], y[1]))
vals2.sort(proc (x, y: (string, int)): int = cmp(x[1], y[1]))

var i = 1
for h in vals1.keys:
    score += i * bids[h]
    i += 1

echo "Part 1: ", score

score = 0
i = 1
for h in vals2.keys:
    score += i * bids[h]
    i += 1

echo "Part 2: ", score
