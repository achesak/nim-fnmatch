# Nim module for filename matching with UNIX shell patterns.
# Based on Python's fnmatch module.

# Written by Adam Chesak.
# Released under the MIT open source license.


## fnmatch is a Nim module for filename matching with UNIX shell patterns. It is based on
## Python's fnmatch module in the standard library.
##
## Examples:
##
## .. code-block:: nimrod
##
##    # Test if a filename matches a pattern, ignoring case.
##    let filename: string = "EXAMPLE.TXT"
##    let pattern: string = "*.txt"
##    var matches: bool = fnmatch(filename, pattern)
##    echo(matches) # outputs true
##
## .. code-block:: nimrod
##
##    # Test if a filename matches a pattern, taking into account case.
##    # Using same filename and pattern as previous example.
##    matches = fnmatchcase(filename, pattern)
##    echo(matches) # outputs false
##
## .. code-block:: nimrod
##
##    # Filter a list of names to get a subset that matches a pattern.
##    let names: seq[string] = @["list", "of", "test.txt", "FILES.TXT", "fnmatch.nim", "fnmatch.testfile"]
##    var filtered: seq[string] = filter(names, "*.t*)
##    echo(filtered)
##    # outputs @["test.txt, "FILES.TXT", "fnmatch.testfile"]
##
##    # filter() can also filter based on case, if true is given as the third parameter.
##    filtered = filter(names, "*.t*", true)
##    echo(filtered)
##    # outputs @["test.txt", "fnmatch.testfile"]


import strutils
import re
import unicode
import lc


proc fnmatchEscapeRe(s: string): string =
    ## Internal proc. Escapes `s` so that it is matched verbatim when used as a regular
    ## expression. Based on the ``escapeRe`` proc in the re module in the Nim standard library.
    var escaped = ""
    for c in items(s):
        case c
        of 'a'..'z', 'A'..'Z', '0'..'9', '_':
            escaped.add(c)
        else:
            escaped.add("\\" & c)
    return escaped


proc translate*(pattern: string): string =
    ## Returns the shell-style ``pattern`` converted to a regular expression.

    var i: int = 0
    var j: int = 0
    var n: int = len(pattern)
    var c: string = ""
    var inside: string = ""
    var output: string = ""

    while i < n:
        c = "" & pattern[i]
        i += 1

        if c == "*":
            output &= ".*"

        elif c == "?":
            output &= "."

        elif c == "[":
            j = i

            if j < n and pattern[j] == '!':
                j += 1
            if j < n and pattern[j] == ']':
                j += 1

            while j < n and pattern[j] != ']':
                j += 1


            if j >= n:
                output &= "\\["
            else:
                inside = pattern[i..j+1].replace("\\", "\\\\")
                i = j + 1

                if inside[0] == '!':
                    inside = "^" & inside[1..high(inside)]
                elif inside[0] == '^':
                    inside = "\\" & inside

                output = output & "[" & inside & "]"

        else:
            output &= fnmatchEscapeRe(c)

    return output & "\\Z(?ms)"


proc fnmatch*(filename: string, pattern: string): bool =
    ## Tests whether ``filename`` matches ``pattern``, returning ``True`` or ``False``.

    let f: string = unicode.toLower(filename)
    let p: string = unicode.toLower(pattern)

    return re.match(f, re(translate(p)))


proc fnmatchcase*(filename: string, pattern: string): bool =
    ## Tests whether ``filename`` matches ``pattern``, returning ``True`` or ``False``;
    ## the comparison is case-sensitive.

    return re.match(filename, re(translate(pattern)))


proc filter*(names: seq[string], pattern: string, casesensitive: bool = false): seq[string] =
    ## Returns the subset of the list of ``names`` that match ``pattern``.
    
    if casesensitive:
        return lc[name | (name <- names, fnmatchcase(name, pattern)), string]
    else:
        return lc[name | (name <- names, fnmatch(name, pattern)), string]

