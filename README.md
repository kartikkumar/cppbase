CppTemplate
===

[![Build Status](https://travis-ci.org/kartikkumar/cpp-template.svg?branch=master)](https://travis-ci.org/kartikkumar/cpp-template)

`CppTemplate` is a template for a simple C++ project. It can be used as the basis for new projects: remember to change all instances of `CppTemplate` to your new project name.

Requirements
------

This project requires the following:

 - [Git](http://git-scm.com)
 - A C++ compiler, e.g., [GCC](https://gcc.gnu.org/), [clang](http://clang.llvm.org/), [MinGW](http://www.mingw.org/)
 - [CMake](http://www.cmake.org)

Installation
------

Run the following commands to download, build this project.

```
git clone https://www.github.com/kartikkumar/cpp-template
cd cpp-template
mkdir build
cd build
cmake ..
cmake --build .
```

To install the header files and libraries, run the following from within the `build` directory:

```
make install
```

Build options
-------------

You can pass the follow command-line options when running `CMake`:

 - `-DBUILD_MAIN=on`: build the main-function
 - `-DBUILD_DOCS=on`: build the [Doxygen](http://www.doxygen.org "Doxygen homepage") documentation
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

See `LICENSE`.

Disclaimer
------

The copyright holders are not liable for any damage(s) incurred due to improper use of `CppTemplate`.

Contact
------

Shoot an [email](mailto:me@kartikkumar.com?subject=CppTemplate) if you have any questions.
