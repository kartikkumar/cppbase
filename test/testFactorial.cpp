/*
 * Copyright (c) <year> <author> (<email>)
 * Distributed under the MIT License.
 * See accompanying file LICENSE.md or copy at http://opensource.org/licenses/MIT
 */

#include <catch.hpp>

#include "cppbase/factorial.hpp"

namespace cppbase
{
namespace tests
{

TEST_CASE( "Test factorial function", "[factorial]" )
{
    REQUIRE_THROWS( computeFactorial( -5 ) );
    REQUIRE( computeFactorial( 0 ) == 1 );
    REQUIRE( computeFactorial( 1 ) == 1 );
    REQUIRE( computeFactorial( 2 ) == 2 );
    REQUIRE( computeFactorial( 5 ) == 120 );
}

} // namespace tests
} // namespace cppbase
