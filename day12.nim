import parseopt
import strutils
import sequtils
import math
import tables

var memo: Table[string, Table[seq[int], int]]

proc cnt_arrange(springs: string, record: seq[int]): int =
    if memo.hasKey(springs) and memo[springs].hasKey(record):
        return memo[springs][record]

    if not memo.hasKey(springs):
        memo[springs] = initTable[seq[int], int]()

    if len(record) == 0 and '#' in springs:
        result = 0
        memo[springs][record] = result
        return result

    if len(record) == 0:
        result = 1
        memo[springs][record] = result
        return result

    if len(springs) < sum(record) + len(record) - 1:
        result = 0
        memo[springs][record] = result
        return result

    if springs[0] == '.':
        result = cnt_arrange(springs[1..^1], record)
        memo[springs][record] = result
        return result

    var first = record[0]
    if springs[0] == '#':
        if any(toSeq(0..<first), proc (x: int): bool = springs[x] == '.'):
            result = 0
            memo[springs][record] = result
            return result
        if len(springs) == first:
            result = 1
            memo[springs][record] = result
            return result
        if springs[first] == '#':
            result = 0
            memo[springs][record] = result
            return result
        
        result = cnt_arrange(springs[first+1..^1], record[1..^1])
        memo[springs][record] = result
        return result

    if any(toSeq(0..<first), proc (x: int): bool = springs[x] == '.'):
        result = cnt_arrange(springs[1..^1], record)
        memo[springs][record] = result
        return result

    if len(springs) == first:
        result = 1
        memo[springs][record] = result
        return result

    if springs[first] == '#':
        result = cnt_arrange(springs[1..^1], record)
        memo[springs][record] = result
        return result
    
    result = cnt_arrange(springs[first+1..^1], record[1..^1]) + cnt_arrange(springs[1..^1], record)
    memo[springs][record] = result
    return result

let p = initOptParser()
let args = p.remainingArgs()
if len(args) != 1:
    echo "File name missing"
    quit()

let fn = args[0]
let f = open(fn)
let data = f.readAll().strip().split("\r\n")
f.close()

var
    l_springs: int
    l_record: int
    springs: string
    record: seq[int]
    total1: int
    total2: int

for i, line in data:
    springs = line.split(' ')[0]
    record = map(line.split(' ')[1].split(','), parseInt)
    
    l_springs = len(springs)
    l_record = len(record)

    total1 += cnt_arrange(springs, record)

    for i in 1..4:
        springs &= "?" & springs[0..<l_springs]
        record &= record[0..<l_record]

    total2 += cnt_arrange(springs, record)

echo "Part 1: ", total1
echo "Part 2: ", total2
