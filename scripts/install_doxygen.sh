#!/bin/bash
# Copyright (c) 2014-2016 Kartik Kumar (me@kartikkumar.com)
# Distributed under the MIT License.
# See accompanying file LICENSE.md or copy at http://opensource.org/licenses/MIT

set -ev

# Fetch and build updated version of Doxygen from source.
wget http://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.11.linux.bin.tar.gz
tar -xzvf doxygen-1.8.11.linux.bin.tar.gz
mv doxygen-1.8.11 $HOME/doxygen