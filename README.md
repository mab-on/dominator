#dominator
dominator is a HTML scraper for the Command-line.

#example
1.
This Example shows a query for a-tags, that are children of a li-tag and has a class Attibute with the value "link".
We want to the output to be "Tag"\t"Element Attributes csv"\t"value of the element Attribute href"\n for each hit 
```sh
$ cat ./dummy.html | ./dominator -f'li.a{class:link}' -o'tag' -o'attrib-keys' -o'attrib(href)'
a	href,id,class	#a-1-li-1-o2-1
a	href,id,class	#a-2-li-2-o2-1
a	href,id,class	#a-3-li-2-o2-1
```

2.
This Example shows a query for a-tags where the href begins with "http"
```sh
$ cat ./dummy.html | ./dominator -f'a{href:(regex)^http}' -o'tag' -o'attrib-keys' -o'attrib(href)'
a	href,id,class	https://github.com
```
