/*
 * Copyright (c) <year> <author> (<email>)
 * Distributed under the MIT License.
 * See accompanying file LICENSE.md or copy at http://opensource.org/licenses/MIT
 */

#ifdef USE_CATCH2

#include <catch2/catch.hpp>

#elif USE_GTEST

#include <gtest/gtest.h>

#endif // USE_CATCH2

#include "cppbase/factorial.hpp"

namespace cppbase
{
namespace tests
{

#ifdef USE_CATCH2

TEST_CASE( "Test factorial function", "[factorial]" )
{
    REQUIRE_THROWS( computeFactorial( -5 ) );
    REQUIRE( computeFactorial( 0 ) == 1 );
    REQUIRE( computeFactorial( 1 ) == 1 );
    REQUIRE( computeFactorial( 2 ) == 2 );
    REQUIRE( computeFactorial( 5 ) == 120 );
}

#elif USE_GTEST

TEST(Factorial, Unit)
{
    ASSERT_ANY_THROW( computeFactorial( -5 ) );
    EXPECT_EQ( computeFactorial( 0 ), 1);
    EXPECT_EQ( computeFactorial( 1 ), 1);
    EXPECT_EQ( computeFactorial( 2 ), 2);
    EXPECT_EQ( computeFactorial( 5 ), 120);
}

#endif // USE_CATCH2

} // namespace tests
} // namespace cppbase
