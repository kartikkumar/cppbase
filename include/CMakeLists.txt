# Copyright (c) 2014-2022 Kartik Kumar (me@kartikkumar.com)
# Distributed under the MIT License.
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT

# The CMake setup for this project is based off of the following source:
# - https://cliutils.gitlab.io/modern-cmake

# Add interface library for a header-only library
# Uncomment add_subdirectory(include) in the main CMakeLists.txt to enable this
add_library(cppbase_lib INTERFACE)
target_include_directories(cppbase_lib INTERFACE .)
