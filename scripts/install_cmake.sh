#!/bin/bash
# Copyright (c) 2014-2016 Kartik Kumar (me@kartikkumar.com)
# Distributed under the MIT License.
# See accompanying file LICENSE.md or copy at http://opensource.org/licenses/MIT

set -ev

# Fetch and build updated version of CMake from source.
# Check to see if CMake folder is empty.
if [ ! -d "$HOME/cmake" ]; then
    wget https://cmake.org/files/v3.4/cmake-3.4.1.tar.gz --no-check-certificate
    tar -xzvf cmake-3.4.1.tar.gz
    cd cmake-3.4.1
    ./bootstrap --prefix=$HOME/cmake
    make
    make install
else
  echo "Using cached CMake directory."
fi