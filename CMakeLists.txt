# Copyright (c) <year>, <author> (<email>)
# Distributed under the MIT License.
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT

cmake_minimum_required(VERSION 2.6)

project(CppTemplate C CXX)

set(${CMAKE_PROJECT_NAME}_VENDOR_NAME        "Kartik Kumar")
set(${CMAKE_PROJECT_NAME}_VENDOR_CONTACT     "me@kartikkumar.com")

set(${CMAKE_PROJECT_NAME}_VERSION_MAJOR      0)
set(${CMAKE_PROJECT_NAME}_VERSION_MINOR      1)
set(${CMAKE_PROJECT_NAME}_VERSION_PATCH      0)
set(CMAKE_PROJECT_VERSION            
    "${${CMAKE_PROJECT_NAME}_VERSION_MAJOR}.${${CMAKE_PROJECT_NAME}_VERSION_MINOR}.${${CMAKE_PROJECT_NAME}_VERSION_PATCH}")

set(PROJECT_PATH                             "${CMAKE_CURRENT_SOURCE_DIR}")
set(EXTERNAL_PATH                            "${PROJECT_PATH}/external")
set(INCLUDE_PATH                             "${PROJECT_PATH}/include")
set(SOURCE_PATH                              "${PROJECT_PATH}/src")
set(TEST_SOURCE_PATH                         "${PROJECT_PATH}/tests")
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

# Allows for external dependencies to be built by CMake.
include(ExternalProject)

find_package(Git REQUIRED)

include_directories(AFTER "${INCLUDE_PATH}")

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

  find_package(CATCH)

  if(NOT CATCH_FOUND)
    # Taken from docs/build-systems.md in the Catch project.
    ExternalProject_Add(
        catch
        PREFIX ${EXTERNAL_PATH}/Catch
        GIT_REPOSITORY https://github.com/philsquared/Catch.git
        TIMEOUT 10
        UPDATE_COMMAND ${GIT_EXECUTABLE} pull
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
        LOG_DOWNLOAD ON
       )

    ExternalProject_Get_Property(catch source_dir)
    set(CATCH_INCLUDE_DIR ${source_dir}/include CACHE INTERNAL "Path to include folder for Catch")
  endif(NOT CATCH_FOUND)
  
  if(NOT APPLE)
    include_directories(SYSTEM AFTER "${CATCH_INCLUDE_DIR}")
  else(APPLE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -isystem \"${CATCH_INCLUDE_DIR}\"")
  endif(NOT APPLE)

  set(CPP_TEMPLATE_TESTS
      "${TEST_SOURCE_PATH}/testCppTemplate.cpp"
      "${TEST_SOURCE_PATH}/testFactorial.cpp"      
  )

  add_executable(cpp_template_tests ${CPP_TEMPLATE_TESTS})
  target_link_libraries(cpp_template_tests cpp_template)
  add_test(NAME cpp_template_tests COMMAND "${TESTS_PATH}/cpp_template_tests")
endif(BUILD_TESTS)

# Install header files and library. 
# Destination is set by CMAKE_INSTALL_PREFIX and defaults to usual locations, unless overridden by
# user.
install(DIRECTORY ${INCLUDE_PATH}/${CMAKE_PROJECT_NAME} 
        DESTINATION include
        FILES_MATCHING PATTERN "*.hpp"
                       PATTERN "*.cpp" EXCLUDE
                       PATTERN "Tests" EXCLUDE)
install(FILES cpp_template_signature DESTINATION include/${CMAKE_PROJECT_NAME})
install(TARGETS cpp_template DESTINATION lib)

# Set up packager.
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${CMAKE_PROJECT_NAME}")
set(CPACK_PACKAGE_VENDOR "${CMAKE_PROJECT_NAME}_VENDOR_NAME")
set(CPACK_PACKAGE_DESCRIPTION_FILE "${PROJECT_PATH}/README.md")
set(CPACK_RESOURCE_FILE_LICENSE "${PROJECT_PATH}/LICENSE.md")
set(CPACK_PACKAGE_VERSION_MAJOR "${${CMAKE_PROJECT_NAME}_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${${CMAKE_PROJECT_NAME}_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${${CMAKE_PROJECT_NAME}_VERSION_PATCH}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "${CMAKE_PROJECT_NAME}")
if(WIN32 AND NOT UNIX)
  # There is a bug in NSI that does not handle full unix paths properly. Make
  # sure there is at least one set of four (4) backlasshes.
  set(CPACK_NSIS_DISPLAY_NAME "${CPACK_PACKAGE_INSTALL_DIRECTORY}")
  set(CPACK_NSIS_CONTACT "${CMAKE_PROJECT_NAME}_VENDOR_CONTACT")
  set(CPACK_NSIS_MODIFY_PATH ON)
else(WIN32 AND NOT UNIX)
endif(WIN32 AND NOT UNIX)
include(CPack)
