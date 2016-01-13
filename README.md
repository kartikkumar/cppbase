CppProject
===

\cond [![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT) [![Build Status](https://travis-ci.org/kartikkumar/cpp-project.svg?branch=master)](https://travis-ci.org/kartikkumar/cpp-project)[![Coverity Scan Build Status](https://scan.coverity.com/projects/3686/badge.svg)](https://scan.coverity.com/projects/3686) [![Coverage Status](https://coveralls.io/repos/kartikkumar/cpp-project/badge.png)](https://coveralls.io/r/kartikkumar/cpp-project) \endcond

`CppProject` is a template for a simple CMake-based C++ project. It can be used as the basis for new projects: remember to change all instances of `CppProject` to your new project name. An example CMake module is available to make it easy to include your project in other CMake-based projects (should be customized): [FindCppProject.cmake](https://github.com/kartikkumar/cmake-modules/Modules/FindCppProject.cmake).

Features
------

  - General directory structure common to C++ projects
  - Example of CMake module
  - Testing framework ([Catch](https://www.github.com/philsquared/Catch "Catch Github repository"))
  - Install script (`make install`)
  - CPack script for packaging (`make package`)
  - Automatic API documentation ([Doxygen](http://www.doxygen.org "Doxygen homepage"))
  - Continuous Integration ([Travis CI](https://travis-ci.org/ "Travis CI homepage"))
  - Code coverage analysis ([Coveralls](https://coveralls.io "Coveralls.io homepage")) (`make coverage`)
  - Example of how to include external dependencies (using `ExternalProject` module)
  - Separate file to specific location of project files (`ProjectFiles.cmake`)

Requirements
------

To install this project, please ensure that you have installed the following (install guides are provided on the respective websites):

  - [Git](http://git-scm.com)
  - A C++ compiler, e.g., [GCC](https://gcc.gnu.org/), [clang](http://clang.llvm.org/), [MinGW](http://www.mingw.org/)
  - [CMake](http://www.cmake.org)
  - [Doxygen](http://www.doxygen.org "Doxygen homepage") (optional)
  - [Gcov](https://gcc.gnu.org/onlinedocs/gcc/Gcov.html) (optional)
  - [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) (optional)

`CppProject`  does not depend on any libraries. The following library is optional (see `Build options`):

  - [CATCH](https://www.github.com/philsquared/Catch) (unit testing library necessary for `BUILD_TESTS` build option)

This dependency will be downloaded and configured automagically if not already present locally (requires an internet connection).

Installation
------

Run the following commands to download, build, and install this project. Substitute "project_name" with the name of your project (if you leave it out, the repository will be cloned to a local folder called "cpp-project"). This will customize the project targets for you. Note that "project_name" must not contain spaces!

    git clone https://www.github.com/kartikkumar/cpp-project <project_name>
    cd <project_name>
    git submodule init && git submodule update
    mkdir build && cd build
    cmake -DPROJECT_NAME=<project_name> .. && cmake --build .

To install the header files, run the following from within the `build` directory:

    make install

Note that dependencies are installed by fetching them online, in case they cannot be detected on your local system. If the build process fails, check the error log given. Typically, building fails due to timeout. Simply run the `cmake --build .` command once more.

Project files can be specified in `ProjectFiles.cmake`.

Build options
-------------

You can pass the following, general command-line options when running CMake:

  - `-DPROJECT_SUMMARY`: set short string summary for your project
  - `-DPROJECT_VENDOR_NAME`: set short string name for vendor of your project
  - `-DPROJECT_VENDOR_CONTACT`: set short string email address for vendor of your project
  - `-DCMAKE_INSTALL_PREFIX[=$install_dir]`: set path prefix for install script (`make install`); if not set, defaults to usual locations
  - `-DBUILD_SHARED_LIBS=[ON|OFF (default)]`: build shared libraries instead of static
  - `-DBUILD_MAIN[=ON|OFF (default)]`: build the main-function
  - `-DBUILD_DOXYGEN_DOCS[=ON|OFF (default)]`: build the [Doxygen](http://www.doxygen.org "Doxygen homepage") documentation ([LaTeX](http://www.latex-project.org/) must be installed with `amsmath` package)
  - `-DBUILD_TESTS[=ON|OFF (default)]`: build tests (execute tests from build-directory using `ctest -V`)
  - `-DBUILD_DEPENDENCIES[=ON|OFF (default)]`: force local build of dependencies, instead of first searching system-wide using `find_package()`

The following command is conditional and can only be set if `BUILD_TESTS = ON`:

 - `-DBUILD_COVERAGE_ANALYSIS[=ON|OFF (default)]`: build code coverage using [Gcov](https://gcc.gnu.org/onlinedocs/gcc/Gcov.html) and [LCOV](http://ltp.sourceforge.net/coverage/lcov.php) (both must be installed; requires [GCC](https://gcc.gnu.org/) compiler; execute coverage analysis from build-directory using `make coverage`)

Pass these options either directly to the `cmake ..` build command or run `ccmake ..` instead to bring up the interface that can be used to toggle options.

Contributing
------------

Once you've made your great commits:

  1. [Fork](https://github.com/kartikkumar/cpp-project/fork) `CppProject`
  2. Create a topic branch - `git checkout -b my_branch`
  3. Push to your branch - `git push origin my_branch`
  4. Create a [Pull Request](http://help.github.com/pull-requests/) from your branch
  5. That's it!

Disclaimer
------

The copyright holders are not liable for any damage(s) incurred due to improper use of `CppProject`.
