# Copyright (c) 2014-2022 Kartik Kumar (me@kartikkumar.com)
# Distributed under the MIT License.
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT

# The CMake setup for this project is based off of the following source:
# - https://cliutils.gitlab.io/modern-cmake

# Make sure that an old version of CMake is not being used so modern features are available
# Update this to the mix, max versions that are applicable
cmake_minimum_required(VERSION 3.14)
if(${CMAKE_VERSION} VERSION_LESS 3.23)
    cmake_policy(VERSION ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION})
else()
    cmake_policy(VERSION 3.23)
endif()

# Set up project details
project(
    cppbase
    VERSION 1.0
    DESCRIPTION "A C++ template project"
    LANGUAGES CXX
    )

# Require out-of-source builds
# Source: https://stackoverflow.com/questions/11143062/getting-cmake-to-build-out-of-source-without-wrapping-scripts
if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
    message(FATAL_ERROR "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there. You may need to remove CMakeCache.txt.")
endif()

# Support folders in IDEs
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Enable downloads during the configure step using FetchContent
# FetchContent was added in CMake 3.11
# FetchContent_MakeAvailable was not added until CMake 3.14
include(FetchContent)

# Instantiate version file based on project details
configure_file (
    "${PROJECT_SOURCE_DIR}/version.hpp.in"
    "${PROJECT_BINARY_DIR}/include/${project_name}/version.hpp"
)

# Add subdirs for headers, sources, and executables
# Subdirs contain CMakeLists.txt files with commands to setup build
# Comment the following line if the library is header-only
add_subdirectory(src)
# Uncomment the following line if the library is header-only
#add_subdirectory(include)
# Comment the following line if there are no applications in this project
add_subdirectory(apps)

# Enable testing
if(BUILD_TESTING)
    include(CTest)
    add_subdirectory(tests)
endif(BUILD_TESTING)

# Build Doxygen docs
if(BUILD_DOCS)
    find_package(Doxygen OPTIONAL_COMPONENTS dot)
    if(Doxygen_FOUND)
        add_subdirectory(docs)
    else()
        message(STATUS "Doxygen not found, not building docs")
    endif(Doxygen_FOUND)
endif(BUILD_DOCS)

# Set up uninstall target to enable 'make uninstall'
# Source: https://gitlab.kitware.com/cmake/community/-/wikis/FAQ#can-i-do-make-uninstall-with-cmake
if(NOT TARGET uninstall)
  configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)

  add_custom_target(uninstall
    COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)
endif()
