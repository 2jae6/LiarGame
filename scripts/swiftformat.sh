#!/bin/sh

if ! command -v swiftformat &> /dev/null; then 
  echo "Swiftformat Skipped"
else
  swiftformat .
fi

