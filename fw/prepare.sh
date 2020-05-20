#!/bin/bash
set -e
(
  mkdir -p src/created
  cd src/created
  git clone https://ohwr.org/project/general-cores.git
  cd general-cores
  # I have done simply:
  # git checkout propose_master
  # but as general-cores may further evolve, and get incompatible 
  # with my codes, here I get the particular commit:
  git checkout 3bbcf4a385999625bfdeac568410f248b017f57f
)
