dominator
---------

dominator is a forgiving HTML-parser for the command-line.

usage & examples
----------------

### Parameters

| Parameter | short | Description |
|-----------|-------|-------------|
| --filter | -f | A Dominator specific filter expression |
| --output-item | -o | Defines the output |
| --output-item-terminator | -t | Character, which terminates one item group on output |
| --output-item-serparator | -s | Character, which separates the items on output |
| --input-file | -i | Read the input from a file instead of stdin |
| --with-html-comments | -c | Include matches in commented html into the output |
| --squash-whitespaces | -w | Removes multiple whitespaces. Only applies to the output-items 'element-strip' , 'element-inner' , 'element' |

#### --output-item: Valid arguments

| Argument | Description |
|----------|-------------|
| tag | The name of the node |
| element-opener | The opening node-tag |
| element | The nodes full content |
| element-inner | The nodes full inner content |
| element-strip | The nodes full inner content without tags |
| element-start | The position of the opening tag in the element |
| element-end | The position of the termination tag in the element |
| attrib-keys | A comma-separated list of the nodes attributes |
| attrib(ATTRIB) | The value of the attribute ATTRIB of the node |

This example shows a query for a-tags, that are children of a li-tag and has a class attibute with the value "link".
We want to the output to be "Tag"\t"Element attributes csv"\t"value of the element ettribute href"\n for each hit
```sh
$ cat ./dummy.html | ./dominator 'li.a{class:link}' -o'tag' -o'attrib-keys' -o'attrib(href)'
a	href,id,class	#a-1-li-1-o2-1
a	href,id,class	#a-2-li-2-o2-1
a	href,id,class	#a-3-li-2-o2-1
```

This Example shows a query for a-tags where the href begins with "http"
```sh
$ cat ./dummy.html | ./dominator 'a{href:(regex)^http}' -o'tag' -o'attrib-keys' -o'attrib(href)'
a	href,id,class	https://github.com
```

# Filter Syntax
Expression = TAG[PICK]{ATTR_NAME:ATTR_VALUE}

Multiple expression can be concatenated  with "." to find stuff inside of specific parent nodes.

| Item | Description | Example |
|------|-------------|---------|
| TAG | The Name of the node | a , p , div , *  |
| [PICK] | (can be ommited) Picks only the n-th match. n begins on 1. PICK can be a list or range | [1] picks the first match , [1,3] picks the first and third , [1..3] picks the first three matches  |
| {ATTR_NAME:ATTR_VALUE} | (can be ommited) The attribute selector | {id:myID} , {class:someClass} , {href:(regex)^http://}  |

Build & install
---------------

### build
`
dub build dominator
`
copy the binary in one of your PATH directories

### use a already build binary
Check out the bin/ directory.
Occasionally i put Windows and Mac binaries in this directory - please be aware, that these binaries usually are not up to date.
