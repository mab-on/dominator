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
        "filter|f",
        "\nA Dominator specific filter expression.\n"
        ~"Examples:\n"
        ~"\t" ~ "div" ~ "\t\t\t" ~ "div nodes." ~ "\n"
        ~"\t" ~ "div.p" ~ "\t\t\t" ~ "p nodes which are direct children of a div." ~ "\n"
        ~"\t" ~ "div[1].p" ~ "\t\t" ~ "p nodes which are direct children of the first div in the document." ~ "\n"
        ~"\t" ~ "div[1..3].p{id:wanted}" ~ "\t" ~ "p nodes with the attribute id='wanted', which are direct children of the first three divs in the document." ~ "\n"
        ~"\t" ~ "div.*{id:wanted}" ~ "\t" ~ "All nodes with the attribute id='wanted' which are direct children of a div." ~ "\n"
        ~"\t" ~ "input{checked:}" ~ "\t\t" ~ "All input nodes with the attribute 'checked'." ~ "\n"
        ~"\t" ~ "a{href:(regex)^http://}" ~ "\t" ~ "a-nodes with a href attribute that matches the regular expression '^http://'." ~ "\n"
        ~"\t" ~ "i{class:(regex)link}" ~ "\t" ~ "i nodes with 'link' as or inside the attribute 'class'." ~ "\n"
        , &optTags,

        "output-item|o",
        "\nDefines the output. Valid arguments are:\n"
        ~"\t" ~ "tag" ~"\t\t" ~ "The name of the node" ~ "\n"
        ~"\t" ~ "element-opener" ~"\t" ~ "The opening node-tag." ~ "\n"
        ~"\t" ~ "element" ~"\t\t" ~ "The nodes full content." ~ "\n"
        ~"\t" ~ "element-inner" ~"\t" ~ "The nodes full inner content." ~ "\n"
        ~"\t" ~ "element-start" ~"\t" ~ "The position of the opening tag in the element." ~ "\n"
        ~"\t" ~ "element-end" ~"\t" ~ "The position of the termination tag in the element." ~ "\n"
        ~"\t" ~ "attrib-keys" ~"\t" ~ "A comma-separated list of the nodes attributes." ~ "\n"
        ~"\t" ~ "attrib(ATTRIB)" ~"\t" ~ "The value of the attribute ATTRIB of the node. " ~ "\n"
        , &optOutItems,

        "output-item-terminator|t",
        "\nCharacter, that terminates one item group on output\n",
        &optNodeTerminator,

        "output-item-serparator|s",
        "\nCharacter, that separates the items on output\n",
        &optNodeSeparator,

        "input-file|i",
        "\nRead the input from a file instead of stdin\n" ,
        &inputFile,

        "with-html-comments|c",
        "",
        &withComments
    );

    if(optResult.helpWanted)
    {
        defaultGetoptPrinter(
            "\ndominator - Command-line HTML scraper.\n"
            ~"Author: Martin Brzenska (martin@mab-on.net)\n"
            ~"Copyright © 2016, Martin Brzenska\n"
	        ~"License: MIT\n"
            ~"\nParameters:\n"
            ,
            optResult.options
        );
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