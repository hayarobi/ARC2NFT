#!/bin/bash

base=`cat base.lua`

process_file() {
  content=`cat ../src/ARC2-$1.lua`
  content="${content//]]/] ]}"
  content="${content//system.getCreator()/_creator:get()}"
  base="${base/"$2"/$content}"
}

process_file "Core" "%core%"
process_file "Burnable" "%burnable%"
process_file "Mintable" "%mintable%"
process_file "Metadata" "%metadata%"
process_file "Pausable" "%pausable%"
process_file "Blacklist" "%blacklist%"
process_file "Approval" "%approval%"
process_file "Searchable" "%searchable%"
process_file "NonTransferable" "%non_transferable%"
process_file "Recallable" "%recallable%"

echo "$base" > output.lua
