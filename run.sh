#!/usr/bin/env bash

if [[ "$1" == "config" ]]; then
	cmake . -B out/debug -G Ninja -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
elif [[ "$1" == "build" ]]; then
	cmake --build out/debug
elif [[ "$1" == "tidy" ]]; then
	python run-clang-tidy.py -config='' -p ./out/debug -header-filter='.*' ./src/*.[ch]pp
else
	echo "not implemented."
fi
