#!/bin/bash

sudo pacman -S --noconfirm --needed  - ollama

ollama run codeqwen

#in vscode donwload extension 
#Continue - Llama 3, GPT-4, and more
#configure this extension
#click on ollama
#then click autodetect.

#go back to main page and select ollama-codeqwen from the drop down menu.
#now change config
#"tabAutocompleteModel": {
#    "title": "codeqwen",
#    "provider": "ollama",
#    "model": "codeqwen"
#  },

# shall we try groqclud
# if pc is to slow

#https://console.groq.com/login
#gen api
#then goto dropdown and find groq and put api key in there

#  "tabAutocompleteModel": {
#    "title": "codeqwen",
#    "provider": "groq",
#   "model": "AUTODETECT"
#  },

