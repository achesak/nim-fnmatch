import fnmatch
import unittest

# Test if a filename matches a pattern, ignoring case.
let filename: string = "EXAMPLE.TXT"
let pattern: string = "*.txt"
var matches: bool = fnmatch(filename, pattern)
test "pattern match":
    check matches == true

# Test if a filename matches a pattern, taking into account case.
# Using same filename and pattern as previous example.
matches = fnmatchcase(filename, pattern)
test "case sensitive pattern match":
    check matches == false

# Filter a list of names to get a subset that matches a pattern.
let names: seq[string] = @["list", "of", "test.txt", "FILES.TXT", "fnmatch.nim",
        "fnmatch.testfile"]
var filtered: seq[string] = filter(names, "*.t*")
test "filter by pattern":
    check filtered.len == 3
# outputs @["test.txt, "FILES.TXT", "fnmatch.testfile"]

# filter() can also filter based on case, if true is given as the third parameter.
filtered = filter(names, "*.t*", true)
test "filter by pattern":
    check filtered.len == 2
# outputs @["test.txt", "fnmatch.testfile"]

