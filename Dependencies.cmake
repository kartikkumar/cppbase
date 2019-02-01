# Copyright (c) <year> <author> (<email>)
# Distributed under the MIT License.
# See accompanying file LICENSE.md or copy at http://opensource.org/licenses/MIT

# Include script to build external libraries with CMake.
include(ExternalProject)

# -------------------------------

# https://computing.llnl.gov/tutorials/pthreads
# Required for GTest.

if(TEST_FRAMEWORK STREQUAL "GTest")
  find_package (Threads REQUIRED)
endif(TEST_FRAMEWORK STREQUAL "GTest")

# -------------------------------

# -------------------------------

# Set up test framework
# Frameworks available: Catch2, GTest
# Catch2: https://github.com/catchorg/Catch2
# GTest: hhttps://github.com/google/googletest


if(BUILD_TESTING)
  if(NOT BUILD_DEPENDENCIES)
    if(TEST_FRAMEWORK STREQUAL "Catch2")
      find_package(Catch2)
      set(TEST_FRAMEWORK_INCLUDE_DIRS ${CATCH2_INCLUDE_DIRS})
      set(TEST_FRAMEWORK_LIB Catch2::Catch2)
    elseif(TEST_FRAMEWORK STREQUAL "GTest")
      set(GTEST_ROOT "${PROJECT_PATH};${PROJECT_PATH}/googletest;${PROJECT_PATH}/googletest/googletest;${PROJECT_PATH}/..;${PROJECT_PATH}/../googletest;${PROJECT_PATH}/../googletest/googletest"
          CACHE PATH "Path to googletest")
      find_package(GTest)
      set(TEST_FRAMEWORK_INCLUDE_DIRS ${GTEST_INCLUDE_DIRS})
      set(TEST_FRAMEWORK_LIB GTest::Main)
    endif(TEST_FRAMEWORK STREQUAL "Catch2")
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

  if((TEST_FRAMEWORK STREQUAL "GTest") AND (NOT GTEST_FOUND))
    message(STATUS "GTest will be downloaded when ${CMAKE_PROJECT_NAME} is built")
    ExternalProject_Add(gtest-lib
      PREFIX ${EXTERNAL_PATH}/GTest
      #--Download step--------------
      URL https://github.com/google/googletest/archive/master.zip
      TIMEOUT 30
      #--Update/Patch step----------
      UPDATE_COMMAND ""
      PATCH_COMMAND ""
      #--Configure step-------------
      SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/gtest
      CONFIGURE_COMMAND ${CMAKE_COMMAND} -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD} ${CMAKE_CURRENT_BINARY_DIR}/gtest/googletest
      #--Build step-----------------
      BUILD_IN_SOURCE 1
      #--Install step---------------
      INSTALL_COMMAND ""
      #--Output logging-------------
      LOG_DOWNLOAD ON
    )
    ExternalProject_Get_Property(gtest-lib source_dir binary_dir)
    add_library(gtest_static INTERFACE)
    add_dependencies(gtest_static gtest-lib)
    target_link_libraries(gtest_static
        INTERFACE "${binary_dir}/lib/${CMAKE_FIND_LIBRARY_PREFIXES}gtest_main.a"
                  "${binary_dir}/lib/${CMAKE_FIND_LIBRARY_PREFIXES}gtest.a")
    target_include_directories(gtest_static INTERFACE "${source_dir}/googletest/include")
    set(TEST_FRAMEWORK_INCLUDE_DIRS ${source_dir}/googletest/include CACHE INTERNAL "Path to include folder for GTest")
    set(TEST_FRAMEWORK_LIB gtest_static)
    link_directories("${binary_dir}/lib")
  endif((TEST_FRAMEWORK STREQUAL "GTest") AND (NOT GTEST_FOUND))

  if(NOT APPLE)
    include_directories(SYSTEM AFTER "${TEST_FRAMEWORK_INCLUDE_DIRS}")
  else(APPLE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -isystem \"${TEST_FRAMEWORK_INCLUDE_DIRS}\"")
  endif(NOT APPLE)
endif(BUILD_TESTING)

# -------------------------------
