# Copyright (c) <year> <author> (<email>)
# Distributed under the MIT License.
# See accompanying file LICENSE.md or copy at http://opensource.org/licenses/MIT

cmake_minimum_required(VERSION 2.6)

# Change this section to correspond with your project info.
project(CppProject C CXX)
set(MYPROJ_DESC                              "A template for a simple C++ project")
set(MYPROJ_UPPER                             "CPP_PROJECT")
set(MYPROJ_EXE                               "cpp_proj_main")
set(MYPROJ_LIB                               "cpp_proj")
set(MYPROJ_TEST                              "test_cpp_proj")
set(${CMAKE_PROJECT_NAME}_VENDOR_NAME        "Kartik Kumar")
set(${CMAKE_PROJECT_NAME}_VENDOR_CONTACT     "me@kartikkumar.com")

set(${CMAKE_PROJECT_NAME}_VERSION_MAJOR      0)
set(${CMAKE_PROJECT_NAME}_VERSION_MINOR      1)
set(${CMAKE_PROJECT_NAME}_VERSION_PATCH      0)
set(MYPROJ_VERSION
  "${${CMAKE_PROJECT_NAME}_VERSION_MAJOR}.${${CMAKE_PROJECT_NAME}_VERSION_MINOR}.${${CMAKE_PROJECT_NAME}_VERSION_PATCH}")

set(MYPROJ_PATH                              "${CMAKE_CURRENT_SOURCE_DIR}")
set(MYEXT_PATH                               "${MYPROJ_PATH}/external")
set(MYINC_PATH                               "${MYPROJ_PATH}/include")
set(MYSRC_PATH                               "${MYPROJ_PATH}/src")
set(MYTEST_SRC_PATH                          "${MYPROJ_PATH}/tests")
set(MYCMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${MYPROJ_PATH}/cmake/Modules")

OPTION(BUILD_MAIN                            "Build main" OFF)
OPTION(BUILD_DOCS                            "Build docs" OFF)
OPTION(BUILD_TESTS                           "Build tests" OFF)
OPTION(BUILD_DEPENDENCIES                    "Build dependencies for current build" OFF)

set(MYPROJ_SRC
  "${MYSRC_PATH}/factorial.cpp"
)

set(MYPROJ_EXE_SRC
  "${MYSRC_PATH}/main.cpp"
)

set(MYPROJ_TEST_SRC
  "${MYTEST_SRC_PATH}/testCppProject.cpp"
  "${MYTEST_SRC_PATH}/testFactorial.cpp"      
)

# Set CMake build-type. If it not supplied by the user, the default built type is "Release". 
if((NOT CMAKE_BUILD_TYPE) OR (CMAKE_BUILD_TYPE STREQUAL "Release"))
    message(STATUS "WARNING: building release version!")
    set(CMAKE_BUILD_TYPE Release)
elseif(CMAKE_BUILD_TYPE STREQUAL "Debug")
    message(STATUS "WARNING: building debug version!")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pg")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pg")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pg")
endif((NOT CMAKE_BUILD_TYPE) OR (CMAKE_BUILD_TYPE STREQUAL "Release"))

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

include_directories(AFTER "${MYINC_PATH}")

# Include script to build external library with CMake.
include(ExternalProject)

if(NOT MYLIB_PATH)
  set(MYLIB_PATH "${PROJECT_BINARY_DIR}/lib")
endif(NOT MYLIB_PATH)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${MYLIB_PATH})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${MYLIB_PATH})
add_library(${MYPROJ_LIB} ${MYPROJ_SRC})

if(BUILD_MAIN)
  if(NOT MYBIN_PATH)
    set(MYBIN_PATH "${PROJECT_BINARY_DIR}/bin")
  endif(NOT MYBIN_PATH)
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${MYBIN_PATH})
  add_executable(${MYPROJ_EXE} ${MYPROJ_EXE_SRC})
  target_link_libraries(${MYPROJ_EXE} ${MYPROJ_LIB})
endif(BUILD_MAIN)

if(BUILD_DOCS)
  find_package(Doxygen)

  if(NOT DOXYGEN_FOUND)
    message(FATAL_ERROR 
            "Doxygen is needed to build the documentation. Please make sure it is installed.")
  endif(NOT DOXYGEN_FOUND)

  configure_file(${MYPROJ_PATH}/Doxyfile.in 
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

  if(NOT MYTESTS_PATH)
    set(MYTESTS_PATH "${PROJECT_BINARY_DIR}/tests")
  endif(NOT MYTESTS_PATH)

  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${MYTESTS_PATH})

  if(NOT BUILD_DEPENDENCIES)
    find_package(CATCH)
  endif(NOT BUILD_DEPENDENCIES)

  if(NOT CATCH_FOUND)
    message(STATUS "Catch will be downloaded when ${CMAKE_PROJECT_NAME} is built")
    ExternalProject_Add(catch
      PREFIX ${MYEXT_PATH}/Catch  
      #--Download step--------------
      URL https://github.com/kartikkumar/Catch/archive/master.zip
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
    ExternalProject_Get_Property(catch source_dir)
    set(CATCH_INCLUDE_DIRS ${source_dir}/include CACHE INTERNAL "Path to include folder for Catch")
  endif(NOT CATCH_FOUND)
  
  if(NOT APPLE)
    include_directories(SYSTEM AFTER "${CATCH_INCLUDE_DIRS}")
  else(APPLE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -isystem \"${CATCH_INCLUDE_DIRS}\"")
  endif(NOT APPLE)  

  add_executable(${MYPROJ_TEST} ${MYPROJ_TEST_SRC})
  target_link_libraries(${MYPROJ_TEST} ${MYPROJ_LIB})
  add_test(NAME ${MYPROJ_TEST} COMMAND "${MYTESTS_PATH}/${MYPROJ_TEST}")
endif(BUILD_TESTS)

# Install header files and library. 
# Destination is set by CMAKE_INSTALL_PREFIX and defaults to usual locations, unless overridden by
# user.
install(DIRECTORY ${MYINC_PATH}/${CMAKE_PROJECT_NAME} 
        DESTINATION include
        FILES_MATCHING PATTERN "*.hpp")
install(TARGETS ${MYPROJ_LIB} DESTINATION lib)

# Install header files and library. 
# Destination is set by CMAKE_INSTALL_PREFIX and defaults to usual locations, unless overridden by
# user.
install(DIRECTORY ${MYINC_PATH}/${CMAKE_PROJECT_NAME} 
        DESTINATION include
        FILES_MATCHING PATTERN "*.hpp")
#install(TARGETS ${MYPROJ_LIB} DESTINATION lib)

# Set up packager.
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${CMAKE_PROJECT_NAME}")
set(CPACK_PACKAGE_VENDOR "${CMAKE_PROJECT_NAME}_VENDOR_NAME")
set(CPACK_PACKAGE_DESCRIPTION_FILE "${MYPROJ_PATH}/README.md")
set(CPACK_RESOURCE_FILE_LICENSE "${MYPROJ_PATH}/LICENSE.md")
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
