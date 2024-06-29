#!/bin/bash
rm -rf dist
poetry install
poetry build
