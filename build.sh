#!/bin/bash
# Ensure we remove old installer versions.
rm -rf dist
set -e
# syntax checking
pyflakes3 test_equipment/*.py
# code style checking
pycodestyle --max-line-length=250 test_equipment/*.py
poetry -vvv build


