# Copyright (c) <year>, <author> (<email>)
# Distributed under the MIT License.
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT

cmake_minimum_required(VERSION 2.6)
project(CppTemplate)

set(PROJECT_PATH                             "${CMAKE_CURRENT_SOURCE_DIR}")
set(SOURCE_PATH                              "${PROJECT_PATH}/${CMAKE_PROJECT_NAME}")
set(CMAKE_MODULE_PATH  ${CMAKE_MODULE_PATH}  "${PROJECT_PATH}/cmake/Modules/")

OPTION(BUILD_MAIN                            "Build main" OFF)
OPTION(BUILD_DOCS                            "Build docs" OFF)
OPTION(BUILD_TESTS                           "Build tests" OFF)

# Set CMake build-type. If it not supplied by the user, the default built type is "Release". 
if((NOT CMAKE_BUILD_TYPE) OR (CMAKE_BUILD_TYPE STREQUAL "Release"))
    message(STATUS "WARNING: building release version!")
    set(CMAKE_BUILD_TYPE Release)
elseif(CMAKE_BUILD_TYPE STREQUAL "Debug")
    message(STATUS "WARNING: building debug version!")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pg")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pg")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pg")
endif()

# Set platform-specific compiler flags.
if (WIN32)
  if (MSVC)
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
  else()
    set(CMAKE_CXX_FLAGS 
        "${CMAKE_CXX_FLAGS} -Wall -Woverloaded-virtual -Wold-style-cast -Wnon-virtual-dtor")
  endif()
else()
  set(CMAKE_CXX_FLAGS 
      "${CMAKE_CXX_FLAGS} -Wall -Woverloaded-virtual -Wold-style-cast -Wnon-virtual-dtor")
endif()

include_directories(AFTER "${PROJECT_PATH}")

set(CPP_TEMPLATE_SOURCES
  "${SOURCE_PATH}/factorial.cpp"
)

if(NOT LIB_PATH)
  set(LIB_PATH "${PROJECT_BINARY_DIR}/lib")
endif(NOT LIB_PATH)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${LIB_PATH})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${LIB_PATH})
add_library(cpp_template ${CPP_TEMPLATE_SOURCES})

if(BUILD_MAIN)
  if(NOT BIN_PATH)
    set(BIN_PATH "${PROJECT_BINARY_DIR}/bin")
  endif(NOT BIN_PATH)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BIN_PATH})
  add_executable(cpptemplate "${SOURCE_PATH}/main.cpp")
  target_link_libraries(cpptemplate cpp_template)
endif(BUILD_MAIN)

if(BUILD_DOCS)
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
  add_custom_target(docs ALL COMMAND ${DOXYGEN_EXECUTABLE} 
                    ${PROJECT_BINARY_DIR}/Doxyfile 
                    SOURCES ${PROJECT_BINARY_DIR}/Doxyfile)
endif(BUILD_DOCS)

if(BUILD_TESTS)
  enable_testing()

  if(NOT TESTS_PATH)
    set(TESTS_PATH "${PROJECT_BINARY_DIR}/tests")
  endif(NOT TESTS_PATH)

  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${TESTS_PATH})

  find_package(CATCH REQUIRED)
  if(NOT APPLE)
    include_directories(SYSTEM AFTER "${CATCH_INCLUDE_DIR}")
  else(APPLE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -isystem \"${CATCH_INCLUDE_DIR}\"")
  endif(NOT APPLE)

  set(CPP_TEMPLATE_TESTS
      "${SOURCE_PATH}/Tests/testCppTemplate.cpp"
      "${SOURCE_PATH}/Tests/testFactorial.cpp"      
  )

  add_executable(cpp_template_tests ${CPP_TEMPLATE_TESTS})
  target_link_libraries(cpp_template_tests cpp_template)
  add_test(NAME cpp_template_tests COMMAND "${TESTS_PATH}/cpp_template_tests")
endif(BUILD_TESTS)

# Install header files and library. 
# Destination is set by CMAKE_INSTALL_PREFIX and defaults to usual locations, unless overridden by
# user.
install(DIRECTORY ${SOURCE_PATH} 
        DESTINATION include
        FILES_MATCHING PATTERN "*.hpp"
                       PATTERN "*.cpp" EXCLUDE
                       PATTERN "Tests" EXCLUDE)
install(TARGETS cpp_template DESTINATION lib)
