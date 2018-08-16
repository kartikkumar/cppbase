# Copyright (c) <year> <author> (<email>)
# Distributed under the MIT License.
# See accompanying file LICENSE.md or copy at http://opensource.org/licenses/MIT

# Include script to build external libraries with CMake.
include(ExternalProject)

# -------------------------------

# Catch2: https://github.com/catchorg/Catch2

if(BUILD_TESTS)
  if(NOT BUILD_DEPENDENCIES)
    find_package(Catch2)
  endif(NOT BUILD_DEPENDENCIES)

  if(NOT CATCH2_FOUND)
    message(STATUS "Catch2 will be downloaded when ${CMAKE_PROJECT_NAME} is built")
    ExternalProject_Add(catch2-lib
      PREFIX ${EXTERNAL_PATH}/Catch2
      #--Download step--------------
      URL https://github.com/catchorg/Catch2/archive/master.zip
      TIMEOUT 30
      #--Update/Patch step----------
      UPDATE_COMMAND ""
      PATCH_COMMAND ""
      #--Configure step-------------
      CONFIGURE_COMMAND ""
      #--Build step-----------------
      BUILD_COMMAND ""
      #--Install step---------------
      INSTALL_COMMAND ""
      #--Output logging-------------
      LOG_DOWNLOAD ON
    )
    ExternalProject_Get_Property(catch2-lib source_dir)
    set(CATCH2_INCLUDE_DIRS ${source_dir}/single_include CACHE INTERNAL "Path to include folder for Catch2")
  endif(NOT CATCH2_FOUND)

  if(NOT APPLE)
    include_directories(SYSTEM AFTER "${CATCH2_INCLUDE_DIRS}")
  else(APPLE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -isystem \"${CATCH2_INCLUDE_DIRS}\"")
  endif(NOT APPLE)
endif(BUILD_TESTS)

# -------------------------------
