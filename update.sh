#!/bin/bash

for f in ./connectors/*.py; do
  echo "run $f"
  $f
done
