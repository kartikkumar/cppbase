# Copyright (c) <year>, <author> (<email>)
# Distributed under the MIT License.
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT

if (CPP_TEMPLATE_INCLUDE_DIRS)
  # in cache already
  set(CPP_TEMPLATE_FOUND TRUE)
else (CPP_TEMPLATE_INCLUDE_DIRS)

  find_path(CPP_TEMPLATE_INCLUDE_DIR
    NAMES
      signature_CppTemplate
    PATHS
      /usr/include
      /usr/local/include
      /opt/local/include
      /sw/include
    PATH_SUFFIXES
  )

  set(CPP_TEMPLATE_INCLUDE_DIRS
    ${CPP_TEMPLATE_INCLUDE_DIR}
  )

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(CATCH DEFAULT_MSG CPP_TEMPLATE_INCLUDE_DIRS)

  # show the CPP_TEMPLATE_INCLUDE_DIRS variables only in the advanced view
  mark_as_advanced(CPP_TEMPLATE_INCLUDE_DIRS)

endif (CPP_TEMPLATE_INCLUDE_DIRS)