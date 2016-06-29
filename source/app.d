/**
 * Copyright:
 * (C) 2016 Martin Brzenska
 *
 * License: 
 * Distributed under the terms of the MIT license. 
 * Consult the provided LICENSE.md file for details
 */
import std.file;
import std.stdio;
import std.getopt;
import std.algorithm;
import std.array : join;

import libdominator;

void main(string[] args)
{

    string[] optTags;
    string optAttribs;
    string[] optOutItems;
    string optNodeSeparator, optNodeTerminator;

    auto optResult = getopt(
        args,
        "fiter|f", "A Dominator specific Filter Expression", &optTags, 
        "filter-attribute|a", "Filters the Nodes, that matches the given Arrtributes", &optAttribs,
        "output-item|o", "Defines the Output", &optOutItems,
        "output-item-terminator|t", "Character, that terminates one item Group on Output", &optNodeTerminator,
        "output-item-serparator|s", "Character, that separates the items on Output", &optNodeSeparator
    );
    
    if(optResult.helpWanted) 
    {
        defaultGetoptPrinter("Some information about the program.",optResult.options);
        return;
    }
    
    if(!optOutItems.length)
    {
        optOutItems = ["element"];
    }
    if(!optNodeTerminator)
    {
        optNodeTerminator = "\n";
    }
    if(!optNodeSeparator)
    {
        optNodeSeparator = "\t";
    }

    string input;
    readf(" %s", &input);

    auto wantedAttributes = AttributeFilter(optAttribs);
    auto domFilterHandler = DomFilter(optTags);

    auto dom = new Dominator(input);

    //Filter and Write out
    foreach(Node node ; dom.getNodes()
    .filterDom(domFilterHandler)
    .filterAttribute(wantedAttributes.attribs)) {
        write(
            join(dom.nodeOutputItems(node,optOutItems),optNodeSeparator)
            ~optNodeTerminator
        );
    }
}
