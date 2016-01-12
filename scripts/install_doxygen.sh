#!/bin/bash
# Copyright (c) 2014-2015 Kartik Kumar (me@kartikkumar.com)
# Distributed under the MIT License.
# See accompanying file LICENSE.md or copy at http://opensource.org/licenses/MIT

set -ev

# Fetch and build updated version of Doxygen from source.
wget http://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.11.src.tar.gz
tar -xzvf doxygen-1.8.11.src.tar.gz
cd doxygen-1.8.11 && ./configure --prefix=$HOME/doxygen && make && make install
