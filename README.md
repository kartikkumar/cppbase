CppTemplate
===

[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT) [![Build Status](https://travis-ci.org/kartikkumar/cpp-template.svg?branch=master)](https://travis-ci.org/kartikkumar/cpp-template)

`CppTemplate` is a template for a simple C++ project. It can be used as the basis for new projects: remember to change all instances of `CppTemplate` to your new project name.

Features
------

  - General directory structure common to C++ projects
  - Example of project CMake module
  - Testing framework ([Catch](https://www.github.com/philsquared/Catch "Catch Github repository"))
  - Install script (`make install`)
  - CPack script for packaging (`make package`)
  - Automatic API documentation ([Doxygen](http://www.doxygen.org "Doxygen homepage"))
  - Continuous Integration ([Travis CI](https://travis-ci.org/ "Travis CI homepage"))
  - Example of how to include external dependencies

Requirements
------

This project requires the following:

  - [Git](http://git-scm.com)
  - A C++ compiler, e.g., [GCC](https://gcc.gnu.org/), [clang](http://clang.llvm.org/), [MinGW](http://www.mingw.org/)
  - [CMake](http://www.cmake.org)

Installation
------

Run the following commands to download, build, and install this project.

    git clone https://www.github.com/kartikkumar/cpp-template
    cd sml
    mkdir build
    cd build
    cmake ..
    cmake --build .

To install the header files and libraries, run the following from within the `build` directory:

    make install

Note that dependencies are installed by fetching them online, in case they cannot be detected on your local system. If the build process fails, check the error log given. Typically, building fails due to timeout. Simply run the `cmake --build .` command once more.

Build options
-------------

You can pass the follow command-line options when running `CMake`:

  - `-DBUILD_MAIN=on`: build the main-function
  - `-DBUILD_DOCS=on`: build the [Doxygen](http://www.doxygen.org "Doxygen homepage") documentation ([LaTeX](http://www.latex-project.org/) must be installed)
  - `-DBUILD_TESTS=on`: build tests (execute tests from build-directory using `make test`)
  - `-DBUILD_SHARED_LIBS=on`: build shared libraries instead of static
  - `-DCMAKE_INSTALL_PREFIX`: set path prefix for install script (`make install`); if not set, defaults to usual locations.

Contributing
------------

Once you've made your great commits:

  1. [Fork](https://github.com/kartikkumar/cpp-template/fork) cpp-template
  2. Create a topic branch - `git checkout -b my_branch`
  3. Push to your branch - `git push origin my_branch`
  4. Create a [Pull Request](http://help.github.com/pull-requests/) from your branch
  5. That's it!

License
------

See `LICENSE.md`.

Disclaimer
------

The copyright holders are not liable for any damage(s) incurred due to improper use of `CppTemplate`.

Contact
------

Shoot an [email](mailto:me@kartikkumar.com?subject=CppTemplate) if you have any questions.

TODO
------

  - Find a way to have nested variables in Doxygen config file so that e.g., `@@CMAKE_PROJECT_NAME@_VERSION@` works.
  - Add version detection in CMake module so that find_package respects minimum version required.
  - Find a better way to deal with external dependencies.
  - Decide whether to include CMake modules as external project.
  - Find a way to provide an option to clean installation.