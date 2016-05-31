About
=====

nim-fnmatch is a Nim module for filename matching with UNIX shell patterns. It is based on Python's fnmatch module in the standard library.

Examples:
 
    # Test if a filename matches a pattern, ignoring case.
    var filename : string = "EXAMPLE.TXT"
    var pattern : string = "*.txt"
    var matches : bool = fnmatch(filename, pattern)
    echo(matches) # outputs true
    
    # Test if a filename matches a pattern, taking into account case.
    # Using same filename and pattern as previous example.
    matches = fnmatchcase(filename, pattern)
    echo(matches) # outputs false

    # Filter a list of names to get a subset that matches a pattern.
    var names : seq[string] = @["list", "of", "test.txt", "FILES.TXT", "fnmatch.nim", "fnmatch.testfile"]
    var filtered : seq[string] = filter(names, "*.t*)
    echo(filtered)
    # outputs @["test.txt, "FILES.TXT", "fnmatch.testfile"]
    
    # filter() can also filter based on case, if true is given as the third parameter.
    filtered = filter(names, "*.t*", true)
    echo(filtered)
    # outputs @["test.txt", "fnmatch.testfile"]

License
=======

nim-fnmatch is released under the MIT open source license.
