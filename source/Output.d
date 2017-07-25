/**
 * Copyright:
 * (C) 2016 Martin Brzenska
 *
 * License:
 * Distributed under the terms of the MIT license.
 * Consult the provided LICENSE.md file for details
 */

import std.conv : to;
import std.array;
import std.algorithm;
import std.string : lastIndexOf;
import std.stdio;

import libdominator.Attribute;
import libdominator.Dominator;
import libdominator.Node;

/**
* Builds a output string.
* This is usefull for formating output for the command-line.
* Params:
*   dom = The DOM Object
*   node = A node, that is part of dom
*   optOutItems = Defines the output contents
*/
string[] nodeOutputItems(ref Dominator dom, Node node, string[] optOutItems)
{
  import std.array : appender;
  string[] columns;
  auto columnsApp = appender(columns);

  foreach(string optOutItem ; optOutItems)
  {
    columnsApp.put(nodeOutputItem(dom , node , optOutItem));
    }
  return columnsApp.data;
}

string nodeOutputItem(ref Dominator dom, Node node, string optOutItem)
{
  switch(optOutItem)
    {
      case "tag":
        return node.getTag();
      case "element":
        return dom.getElement(node);
      case "element-opener":
        return dom.getStartElement(node);
      case "element-start-length":
        return to!string(node.getStartTagLength());
      case "element-end-length":
        return to!string(node.getEndTagLength());
      case "element-start":
        return to!string(node.getStartPosition());
      case "element-end":
        return to!string(node.getEndPosition());
      case "element-inner":
        return dom.getInner(node);
      case "element-strip":
        return dom.stripTags(node);
      case "attrib-keys":
        return join(map!(a => a.key)(node.getAttributes()),",");
      default:
        /*
        * some CLI-Arguments are parametrized, lets check them
        */
        if(optOutItem.length > 7 && optOutItem[0..7] == "attrib(")
        {
          size_t closerIndex = lastIndexOf(optOutItem, ")");
          if(closerIndex)
          {
            string[] keyvalues;
            foreach(Attribute fAttrib ; node.getAttributes().filter!(a => a.key == optOutItem[7..closerIndex]))
            {
              keyvalues ~= fAttrib.values;
            }
            return join(keyvalues, ",");
          }
        }
        /*
        * If no "OutItem" matches, output he input right away.
        */
        return optOutItem;
    }
}

