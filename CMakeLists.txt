# Copyright (c) <year> <author> (<email>)
# Distributed under the MIT License.
# See accompanying file LICENSE.md or copy at http://opensource.org/licenses/MIT

cmake_minimum_required(VERSION 2.6)

# Check if project name has been specified correctly.
if((NOT PROJECT_NAME))
  message(FATAL_ERROR "Project name must be specified!")
endif ((NOT PROJECT_NAME))
if(${PROJECT_NAME} MATCHES " ")
    message(FATAL_ERROR "Project name cannot contain spaces!")
endif(${PROJECT_NAME} MATCHES " ")

# Change this section to correspond with your project info.
project(${PROJECT_NAME} C CXX)
set(${CMAKE_PROJECT_NAME}_SUMMARY              "${PROJECT_SUMMARY}")
set(${CMAKE_PROJECT_NAME}_VENDOR_NAME          "${PROJECT_VENDOR_NAME}")
set(${CMAKE_PROJECT_NAME}_VENDOR_CONTACT       "${PROJECT_VENDOR_CONTACT}")
set(${CMAKE_PROJECT_NAME}_VERSION_MAJOR        0)
set(${CMAKE_PROJECT_NAME}_VERSION_MINOR        0)
set(${CMAKE_PROJECT_NAME}_VERSION_PATCH        0)
set(PROJECT_VERSION
  "${${CMAKE_PROJECT_NAME}_VERSION_MAJOR}.${${CMAKE_PROJECT_NAME}_VERSION_MINOR}.${${CMAKE_PROJECT_NAME}_VERSION_PATCH}")

set(PROJECT_PATH                               "${CMAKE_CURRENT_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}     "${PROJECT_PATH}/cmake/Modules")
set(INCLUDE_PATH                               "${PROJECT_PATH}/include")
set(SRC_PATH                                   "${PROJECT_PATH}/src")
set(TEST_SRC_PATH                              "${PROJECT_PATH}/test")
if(NOT EXTERNAL_PATH)
  set(EXTERNAL_PATH                            "${PROJECT_PATH}/external")
endif(NOT EXTERNAL_PATH)
if(NOT DOXYGEN_PATH)
  set(DOXYGEN_PATH                             "${PROJECT_PATH}/doxydocs")
endif(NOT DOXYGEN_PATH)
if(NOT DOCS_PATH)
  set(DOCS_PATH                                "${PROJECT_PATH}/docs")
endif(NOT DOCS_PATH)
set(LIB_PATH                                   "${PROJECT_BINARY_DIR}/lib")
set(LIB_NAME                                   "${PROJECT_NAME}")
set(BIN_PATH                                   "${PROJECT_BINARY_DIR}/bin")
set(MAIN_NAME                                  "${PROJECT_NAME}_main")
set(TEST_PATH                                  "${PROJECT_BINARY_DIR}/test")
set(TEST_NAME                                  "test_${PROJECT_NAME}")

OPTION(BUILD_MAIN                              "Build main function"            ON)
OPTION(BUILD_DOXYGEN_DOCS                      "Build docs"                     OFF)
OPTION(BUILD_TESTS                             "Build tests"                    OFF)
OPTION(BUILD_DEPENDENCIES                      "Force build of dependencies"    OFF)

include(CMakeDependentOption)
CMAKE_DEPENDENT_OPTION(BUILD_COVERAGE_ANALYSIS "Build code coverage analysis"   OFF
                                               "BUILD_TESTS"                    OFF)

include(ProjectFiles.cmake)

# Set CMake build-type. If it not supplied by the user, the default built type is "Release".
if(((NOT CMAKE_BUILD_TYPE)
  AND (NOT BUILD_COVERAGE_ANALYSIS))
  OR (CMAKE_BUILD_TYPE STREQUAL "Release"))
    message(STATUS "WARNING: building release version!")
    set(CMAKE_BUILD_TYPE Release)
elseif((CMAKE_BUILD_TYPE STREQUAL "Debug") OR (BUILD_COVERAGE_ANALYSIS))
    message(STATUS "WARNING: building debug version!")
endif(((NOT CMAKE_BUILD_TYPE)
  AND (NOT BUILD_COVERAGE_ANALYSIS))
  OR (CMAKE_BUILD_TYPE STREQUAL "Release"))

# Set platform-specific compiler flags.
if(WIN32)
  if(MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /EHsc /Ox /W3 /FC -D_SCL_SECURE_NO_WARNINGS")
    # We need to force MSVC to use static runtime:
    # (from http://www.cmake.org/Wiki/CMake_FAQ#Dynamic_Replace).
    foreach(flag_var
      CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE
      CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO)
      # Find all dynamic runtime (MD) references and replace with static (MT)
      if(${flag_var} MATCHES "/MD")
        string(REGEX REPLACE "/MD" "/MT" ${flag_var} "${${flag_var}}")
      endif(${flag_var} MATCHES "/MD")
    endforeach(flag_var)
  else(MSVC)
    set(CMAKE_CXX_FLAGS
      "${CMAKE_CXX_FLAGS} -Wall -Woverloaded-virtual -Wold-style-cast -Wnon-virtual-dtor")
  endif(MSVC)
else(WIN32)
  set(CMAKE_CXX_FLAGS
    "${CMAKE_CXX_FLAGS} -Wall -Woverloaded-virtual -Wold-style-cast -Wnon-virtual-dtor")
endif(WIN32)

if(CMAKE_COMPILER_IS_GNUCXX)
    set(CMAKE_CXX_FLAGS_DEBUG   "-O0 -g3")
    set(CMAKE_CXX_FLAGS_RELEASE "-O3")
    set(CMAKE_CXX_FLAGS         "${CMAKE_CXX_FLAGS} -fprofile-arcs -ftest-coverage")
endif(CMAKE_COMPILER_IS_GNUCXX)

include_directories(AFTER "${INCLUDE_PATH}")

include(Dependencies.cmake)

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${LIB_PATH})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${LIB_PATH})
add_library(${LIB_NAME} ${SRC})

if(BUILD_MAIN)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BIN_PATH})
  add_executable(${MAIN_NAME} ${MAIN_SRC})
  target_link_libraries(${MAIN_NAME} ${LIB_NAME})
endif(BUILD_MAIN)

if(BUILD_DOXYGEN_DOCS)
  find_package(Doxygen)

  if(NOT DOXYGEN_FOUND)
    message(FATAL_ERROR
            "Doxygen is needed to build the documentation. Please make sure it is installed.")
  endif(NOT DOXYGEN_FOUND)

  configure_file(${PROJECT_PATH}/Doxyfile.in
                 ${PROJECT_BINARY_DIR}/Doxyfile @ONLY IMMEDIATE)

  # Add a custom target to run Doxygen whenever the project is built.
  # If you do NOT want the documentation to be generated EVERY time you build the project
  # then leave out the 'ALL' keyword from the command below.
  add_custom_target(doxygen_docs ALL COMMAND ${DOXYGEN_EXECUTABLE}
                    ${PROJECT_BINARY_DIR}/Doxyfile
                    SOURCES ${PROJECT_BINARY_DIR}/Doxyfile)
endif(BUILD_DOXYGEN_DOCS)

if(BUILD_TESTS)
  enable_testing()
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${TEST_PATH})

  add_executable(${TEST_NAME} ${TEST_SRC})
  target_link_libraries(${TEST_NAME} ${LIB_NAME})
  add_test(NAME ${TEST_NAME} COMMAND "${TEST_PATH}/${TEST_NAME}")

  if(BUILD_COVERAGE_ANALYSIS)
    include(CodeCoverage)
    set(COVERAGE_EXTRACT '${PROJECT_PATH}/include/*' '${PROJECT_PATH}/src/*')
    setup_target_for_coverage(coverage "${TEST_NAME}" coverage)
  endif(BUILD_COVERAGE_ANALYSIS)
endif(BUILD_TESTS)

# Install header files and library.
# Destination is set by CMAKE_INSTALL_PREFIX and defaults to usual locations, unless overridden by
# user.
install(DIRECTORY ${INCLUDE_PATH}/${CMAKE_PROJECT_NAME}
        DESTINATION include
        FILES_MATCHING PATTERN "*.hpp")
install(TARGETS ${LIB_NAME} DESTINATION lib)
install(TARGETS ${BIN_NAME} DESTINATION bin)

# Set up packager.
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${CMAKE_PROJECT_NAME}")
set(CPACK_PACKAGE_VENDOR              "${CMAKE_PROJECT_NAME}_VENDOR_NAME")
set(CPACK_PACKAGE_DESCRIPTION_FILE    "${PROJECT_PATH}/README.md")
set(CPACK_RESOURCE_FILE_LICENSE       "${PROJECT_PATH}/LICENSE.md")
set(CPACK_PACKAGE_VERSION_MAJOR       "${${CMAKE_PROJECT_NAME}_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR       "${${CMAKE_PROJECT_NAME}_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH       "${${CMAKE_PROJECT_NAME}_VERSION_PATCH}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY   "${CMAKE_PROJECT_NAME}")
if(WIN32 AND NOT UNIX)
  # There is a bug in NSI that does not handle full unix paths properly. Make
  # sure there is at least one set of four (4) backlasshes.
  set(CPACK_NSIS_DISPLAY_NAME         "${CPACK_PACKAGE_INSTALL_DIRECTORY}")
  set(CPACK_NSIS_CONTACT              "${CMAKE_PROJECT_NAME}_VENDOR_CONTACT")
  set(CPACK_NSIS_MODIFY_PATH ON)
else(WIN32 AND NOT UNIX)
endif(WIN32 AND NOT UNIX)
include(CPack)
