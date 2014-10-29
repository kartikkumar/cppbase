# Source: https://github.com/Fastcode/NUClear/blob/develop/cmake/Modules/FindCATCH.cmake
# Author: T. Houliston
# Date: 20th June, 2013

if (CATCH_INCLUDE_DIRS)
  # in cache already
  set(CATCH_FOUND TRUE)
else (CATCH_INCLUDE_DIRS)

  find_path(CATCH_INCLUDE_DIR
    NAMES
      catch.hpp
      catch.h
    PATHS
      /usr/include
      /usr/local/include
      /opt/local/include
      /sw/include
      C:
      ${PROJECT_PATH}
      ${EXTERNAL_PATH}
    PATH_SUFFIXES 
      Catch/include Catch/src/include
  )

  set(CATCH_INCLUDE_DIRS
    ${CATCH_INCLUDE_DIR}
  )

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(CATCH DEFAULT_MSG CATCH_INCLUDE_DIRS)

  # show the CATCH_INCLUDE_DIRS variables only in the advanced view
  mark_as_advanced(CATCH_INCLUDE_DIRS)

endif (CATCH_INCLUDE_DIRS)