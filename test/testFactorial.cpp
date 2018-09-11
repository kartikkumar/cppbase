/*
 * Copyright (c) <year> <author> (<email>)
 * Distributed under the MIT License.
 * See accompanying file LICENSE.md or copy at http://opensource.org/licenses/MIT
 */

#ifndef USE_GTEST

#include <catch2/catch.hpp>

#else

#include <gtest/gtest.h>

#endif

#include "cppbase/factorial.hpp"

namespace cppbase
{
namespace tests
{

#ifndef USE_GTEST
TEST_CASE( "Test factorial function", "[factorial]" )
{
    REQUIRE_THROWS( computeFactorial( -5 ) );
    REQUIRE( computeFactorial( 0 ) == 1 );
    REQUIRE( computeFactorial( 1 ) == 1 );
    REQUIRE( computeFactorial( 2 ) == 2 );
    REQUIRE( computeFactorial( 5 ) == 120 );
}
#else
TEST(Factorial, Unit)
{
    ASSERT_ANY_THROW( computeFactorial( -5 ) );
    EXPECT_EQ( computeFactorial( 0 ), 1);
    EXPECT_EQ( computeFactorial( 1 ), 1);
    EXPECT_EQ( computeFactorial( 2 ), 2);
    EXPECT_EQ( computeFactorial( 5 ), 120);
}
#endif
} // namespace tests
} // namespace cppbase
