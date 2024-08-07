#!/bin/sh
# twine must be installed
# E.G
# python3 -m pip install --user --upgrade twine

python3 -m twine upload --verbose --repository testpypi dist/*

# To send project to pypi
# python3 -m twine upload --repository pypi dist/*