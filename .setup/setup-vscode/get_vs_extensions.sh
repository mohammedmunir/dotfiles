#!/bin/bash
#Explanation: The user wants to list all VS Code extensions and save the output to a file named `extensions.txt`. The command `code --list-extensions` lists all installed extensions, and the `> extensions.txt` redirects the output to a file named `extensions.txt`.
code --list-extensions > extensions.txt
