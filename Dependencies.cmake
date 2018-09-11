# Copyright (c) <year> <author> (<email>)
# Distributed under the MIT License.
# See accompanying file LICENSE.md or copy at http://opensource.org/licenses/MIT

# Include script to build external libraries with CMake.
include(ExternalProject)

# -------------------------------

# Catch2: https://github.com/catchorg/Catch2

if(BUILD_TESTS)
  if(NOT BUILD_DEPENDENCIES)
    if(TEST_FRAMEWORK STREQUAL "Catch2")
      find_package(Catch2)
      set(TEST_FRAMEWORK_INCLUDE_DIRS ${CATCH2_INCLUDE_DIRS})
      set(TEST_FRAMEWORK_LIB Catch2::Catch2)
    endif(TEST_FRAMEWORK STREQUAL "Catch2")
    if(TEST_FRAMEWORK STREQUAL "GTest")
      find_package(GTest)
      set(TEST_FRAMEWORK_INCLUDE_DIRS ${gtest_SOURCE_DIR}/include ${gtest_SOURCE_DIR})
      set(TEST_FRAMEWORK_LIB GTest::Main)
    endif(TEST_FRAMEWORK STREQUAL "GTest")
  endif(NOT BUILD_DEPENDENCIES)


  if((TEST_FRAMEWORK STREQUAL "Catch2") AND (NOT CATCH2_FOUND))
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
    set(TEST_FRAMEWORK_INCLUDE_DIRS ${source_dir}/single_include CACHE INTERNAL "Path to include folder for Catch2")
    set(TEST_FRAMEWORK_LIB catch2-lib)
  endif((TEST_FRAMEWORK STREQUAL "Catch2") AND (NOT CATCH2_FOUND))

  # TODO: Add Download option for GTest

  if(NOT APPLE)
    include_directories(SYSTEM AFTER "${TEST_FRAMEWORK_INCLUDE_DIRS}")
  else(APPLE)
    # TODO: Test GTest on APPLE
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -isystem \"${TEST_FRAMEWORK_INCLUDE_DIRS}\"")
  endif(NOT APPLE)

endif(BUILD_TESTS)

# -------------------------------
