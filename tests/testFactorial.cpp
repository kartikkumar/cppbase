/*
 * Copyright (c) <year> <author> (<email>)
 * Distributed under the MIT License.
 * See accompanying file LICENSE.md or copy at http://opensource.org/licenses/MIT
 */

#include <catch2/catch_test_macros.hpp>

#include "cppbase/factorial.hpp"

namespace cppbase
{
namespace tests
{

TEST_CASE( "Compute factorials", "[factorial]" )
{
    REQUIRE( computeFactorial(1) == 1 );
    REQUIRE( computeFactorial(2) == 2 );
    REQUIRE( computeFactorial(3) == 6 );
    REQUIRE( computeFactorial(10) == 3628800 );
}

} // namespace tests
} // namespace cppbase