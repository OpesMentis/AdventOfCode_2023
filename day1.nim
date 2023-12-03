import std/parseopt
import strutils
import tables

proc calibration_value(line: string, part2 = false): int =
    var nb = {
        "1": 1, "2": 2, "3": 3, "4": 4, "5": 5,
        "6": 6, "7": 7, "8": 8, "9": 9
    }.toTable

    if part2:
        nb["one"] = 1
        nb["two"] = 2
        nb["three"] = 3
        nb["four"] = 4
        nb["five"] = 5
        nb["six"] = 6
        nb["seven"] = 7
        nb["eight"] = 8
        nb["nine"] = 9

    var xtr: string

    block nb1:
        for i in 0 .. len(line):
            for ch in nb.keys:
                xtr = line.substr(i)
                if xtr.startsWith(ch):
                    result = nb[ch] * 10
                    break nb1
    
    block nb2:
        for i in countdown(len(line), 0):
            for ch in nb.keys:
                xtr = line.substr(i)
                if xtr.startsWith(ch):
                    result += nb[ch]
                    break nb2

let p = initOptParser()
let args = p.remainingArgs()
if len(args) != 1:
    echo "File name missing"
    quit()

let fn = args[0]
let f = open(fn)
let data = f.readAll().strip().split("\n")
f.close()

var s1 = 0
var s2 = 0

for line in data:
    s1 += calibration_value(line)
    s2 += calibration_value(line, true)

echo "Part 1: " & $s1
echo "Part 2: " & $s2
