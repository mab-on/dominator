dominator
---------

dominator is a forgiving HTML-Parser for the Command-line.

usage & examples
----------------

###Parameters
| Parameter | short | Description |
|-----------|-------|-------------|
| --filter | -f | A Dominator specific Filter Expression |
| --output-item | -o | Defines the Output |
| --output-item-terminator | -t | Character, that terminates one item Group on Output |
| --output-item-serparator | -s | Character, that separates the items on Output |
| --input-file | -i | Read the Input from a File instead of stdin |
| --with-html-comments |  | include matches in commented html into the output |

This Example shows a query for a-tags, that are children of a li-tag and has a class Attibute with the value "link".
We want to the output to be "Tag"\t"Element Attributes csv"\t"value of the element Attribute href"\n for each hit 
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

Install
-------

`
dub build dominator
`
copy the binary in one of your PATH directories

If you are using MS Windows, you can take the binary file from the bin/ Directory
