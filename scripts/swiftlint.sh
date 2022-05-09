#!/bin/sh

if ! command -v swiftlint &>/dev/null; then 
  echo "SwiftLint Skipped"
else
  swiftlint --fix
fi
