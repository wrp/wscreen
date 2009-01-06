#!/bin/sh

# This script will bootstrap a git working directory.
# You'll need to have gnulib available, with its
# toplevel dir in your PATH.
gnulib-tool --update
autoreconf --install --verbose
