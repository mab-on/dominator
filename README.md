dominator
---------

dominator is a forgiving HTML-Parser for the Command-line.

usage & examples
----------------

###Parameters

| Parameter | short | Description |
|-----------|-------|-------------|
| --filter | -f | A Dominator specific filter expression |
| --output-item | -o | Defines the output |
| --output-item-terminator | -t | Character, that terminates one item group on output |
| --output-item-serparator | -s | Character, that separates the items on output |
| --input-file | -i | Read the input from a file instead of stdin |
| --with-html-comments |  | include matches in commented html into the output |

This example shows a query for a-tags, that are children of a li-tag and has a class attibute with the value "link".
We want to the output to be "Tag"\t"Element attributes csv"\t"value of the element ettribute href"\n for each hit 
```sh
$ cat ./dummy.html | ./dominator -f'li.a{class:link}' -o'tag' -o'attrib-keys' -o'attrib(href)'
a	href,id,class	#a-1-li-1-o2-1
a	href,id,class	#a-2-li-2-o2-1
a	href,id,class	#a-3-li-2-o2-1
```

This Example shows a query for a-tags where the href begins with "http"
```sh
$ cat ./dummy.html | ./dominator -f'a{href:(regex)^http}' -o'tag' -o'attrib-keys' -o'attrib(href)'
a	href,id,class	https://github.com
```

#Filter Syntax
Expression = TAG[PICK]{ATTR_NAME:ATTR_VALUE}

Multiple expression can be concatenated  with "." to find stuff inside of specific parent nodes.

| Item | Description | Example |
|------|-------------|---------|
| TAG | The Name of the node | a , p , div , *  |
| [PICK] | (can be ommited) Picks only the n-th match. n begins on 1. PICK can be a list or range | [1] picks the first match , [1,3] picks the first and third , [1..3] picks the first three matches  |
| {ATTR_NAME:ATTR_VALUE} | (can be ommited) The attribute selector | {id:myID} , {class:someClass} , {href:(regex)^http://}  |

Build & install
---------------

###build
`
dub build dominator
`
copy the binary in one of your PATH directories

###use a already build binary
Check out the bin/ directory. 
Occasionally i put Windows and Mac binaries in this directory - please be aware, that these binaries usually are not up to date. 
