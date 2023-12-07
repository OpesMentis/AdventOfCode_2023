import parseopt
import strutils
import tables
import math
import algorithm

proc eval_hand(hand: string): int =
    const kinds = "23456789TJQKA"
    let cards = hand.toCountTable()
    let max_occ = cards.largest()[1]

    for c in hand:
        result *= 13
        result += kinds.find(c)

    if len(cards) == 1:
        result += 6 * 13^5
    elif len(cards) == 2 and max_occ == 4:
        result += 5 * 13^5
    elif len(cards) == 2:
        result += 4 * 13^5
    elif len(cards) == 3 and max_occ == 3:
        result += 3 * 13^5
    elif len(cards) == 3:
        result += 2 * 13^5
    elif len(cards) == 4:
        result += 13^5

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
var vals: OrderedTable[string, int]
var info: seq[string]
var hand: string
var score: int
var i = 1

for line in data:
    info = line.strip().split(" ")
    hand = info[0]

    bids[hand] = parseInt(info[1])
    vals[hand] = eval_hand(hand)

vals.sort(proc (x, y: (string, int)): int = cmp(x[1], y[1]))

for h in vals.keys:
    score += i * bids[h]
    i += 1

echo "Part 1: ", score
