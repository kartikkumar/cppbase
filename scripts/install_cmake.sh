#!/bin/bash
# Copyright (c) 2014-2016 Kartik Kumar (me@kartikkumar.com)
# Distributed under the MIT License.
# See accompanying file LICENSE.md or copy at http://opensource.org/licenses/MIT

set -ev

# Fetch and build updated version of CMake from source.
wget https://cmake.org/files/v3.4/cmake-3.4.1.tar.gz
tar -xzvf cmake-3.4.1.tar.gz
cd cmake-3.4.1
./bootstrap
make
make install