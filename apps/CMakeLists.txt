# Copyright (c) <year> <author> (<email>)
# Distributed under the MIT License.
# See accompanying file LICENSE.md or copy at http://opensource.org/licenses/MIT

# The CMake setup for this project is based off of the following source:
# - https://cliutils.gitlab.io/modern-cmake

# Create executables and link necessary libraries for each app in this file

# Set up main application
add_executable(cppbase cppbase.cpp)
target_compile_features(cppbase PRIVATE cxx_std_11)
target_link_libraries(cppbase PRIVATE cppbase_lib)

# Set up Hellow World application
add_executable(helloWorld helloWorld.cpp)
target_compile_features(helloWorld PRIVATE cxx_std_11)
target_link_libraries(helloWorld PRIVATE cppbase_lib)