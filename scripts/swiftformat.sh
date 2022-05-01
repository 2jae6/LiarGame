#!/bin/sh

if ! command -v swiftformat &> /dev/null; then 
  brew install swiftformat
else
  swiftformat .
fi

