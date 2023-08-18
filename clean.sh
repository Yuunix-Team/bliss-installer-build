#!/bin/bash

. .rc

ckroot

rm -rf build dist tmp

cd gearlock
make clean
cd ..
