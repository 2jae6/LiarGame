#!/bin/sh

if ! command -v swiftlint &>/dev/null; then 
  brew install swiftlint
else
  swiftlint --fix
fi
