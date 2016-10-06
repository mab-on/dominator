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

int main(string[] args)
{

    string[] optTags;
    string optAttribs;
    string[] optOutItems;
    string optNodeSeparator, optNodeTerminator;
    string inputFile;
    bool withComments = false;

    auto optResult = getopt(
        args,
        "filter|f", "A Dominator specific Filter Expression", &optTags,
        "output-item|o", "Defines the Output", &optOutItems,
        "output-item-terminator|t", "Character, that terminates one item Group on Output", &optNodeTerminator,
        "output-item-serparator|s", "Character, that separates the items on Output", &optNodeSeparator,
        "input-file|i", "Read the Input from a File instead of stdin" , &inputFile,
        "with-html-comments","", &withComments
    );
    
    if(optResult.helpWanted) 
    {
        defaultGetoptPrinter("Some information about the program.",optResult.options);
        return 0;
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
    if(!inputFile) {
        readf(" %s", &input);
    }
    else {
        try {
            input = readText(inputFile);
        }
        catch (FileException e) {
            writeln("The Input File could not be read");
            return 1;
        }
    }
    

    auto domFilterHandler = DomFilter(optTags);
    auto dom = new Dominator(input);

    //Filter and Write out
    Node[] nodes = dom.getNodes().filterDom(domFilterHandler);
    if( ! withComments) {
        nodes = nodes.filterComments();
    }
    foreach(Node node ; nodes) {
        write(join(dom.nodeOutputItems(node,optOutItems),optNodeSeparator)~optNodeTerminator);
    }
    return 0;
}