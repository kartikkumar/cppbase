#!/bin/bash
# Copyright (c) 2014-2015 Kartik Kumar (me@kartikkumar.com)
# Distributed under the MIT License.
# See accompanying file LICENSE.md or copy at http://opensource.org/licenses/MIT

set -ev

# Uninstall doxygen install. Fetch and build updated version from source.
yes | sudo apt-get --purge remove doxygen;
sudo apt-get install bison;
sudo apt-get install mscgen;
git clone https://github.com/doxygen/doxygen.git;
cd doxygen;
./configure;
make;
sudo make install;
sudo ln -s /usr/local/bin/doxygen /usr/bin/;
