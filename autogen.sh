#!/bin/sh

# This script will bootstrap a git working directory.
# You'll need to have gnulib available, with its
# toplevel dir in your PATH.
# To obtain gnulib, you might try:
#
# cd $HOME
# git clone git://git.savannah.gnu.org/gnulib
# export PATH=$PATH:$HOME/gnulib

gnulib-tool --update &&
autoreconf --install --verbose
