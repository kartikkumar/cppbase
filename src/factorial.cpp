/*
 * Copyright (c) 2014-2022 Kartik Kumar (me@kartikkumar.com)
 * Distributed under the MIT License.
 * See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT
 */

#include <cassert>

#include "cppbase/factorial.hpp"

namespace cppbase
{

//! Compute factorial.
int computeFactorial(const int integerNumber)
{
	assert(integerNumber >= 0);
	return (integerNumber == 0) ? 1 : integerNumber * computeFactorial(integerNumber-1);
}

} // namespace cppbase
