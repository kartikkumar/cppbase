#!/bin/bash
# Copyright (c) 2014-2018 Kartik Kumar (me@kartikkumar.com)
# Distributed under the MIT License.
# See accompanying file LICENSE.md or copy at http://opensource.org/licenses/MIT

set -ev

# Fetch and build updated version of Doxygen from source.
wget https://github.com/doxygen/doxygen/archive/Release_1_8_14.zip
unzip Release_1_8_14.zip
mv doxygen-Release_1_8_14 $HOME/doxygen
cd $HOME/doxygen
mkdir build
cd build
cmake -G "Unix Makefiles" ..
make