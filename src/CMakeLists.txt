# Copyright (c) 2014-2022 Kartik Kumar (me@kartikkumar.com)
# Distributed under the MIT License.
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT

# The CMake setup for this project is based off of the following source:
# - https://cliutils.gitlab.io/modern-cmake

# -----------------------------------------------

# List all files that should be included in the library here
set(
  SOURCE_LIST
  factorial.cpp
  )

# -----------------------------------------------

# Grab a list of all header files
file(GLOB HEADER_LIST CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/include/cppbase/*.hpp")

# Make an automatic library - will be static or dynamic based on user setting
# Note that headers are optional, and do not affect add_library, but they will not
# show up in IDEs unless they are listed in add_library
add_library(
  cppbase_lib
  ${SOURCE_LIST}
  ${HEADER_LIST}
)
target_include_directories(cppbase_lib PUBLIC ../include)
target_compile_features(cppbase_lib PUBLIC cxx_std_11)

# IDEs should put the headers in a nice place
source_group(
  TREE "${PROJECT_SOURCE_DIR}/include"
  PREFIX "Header Files"
  FILES ${HEADER_LIST}
  )
