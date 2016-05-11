/*
 * Copyright (c) <year> <author> (<email>)
 * Distributed under the MIT License.
 * See accompanying file LICENSE.md or copy at http://opensource.org/licenses/MIT
 */

#include <sstream>
#include <stdexcept>

#include "cppbase/factorial.hpp"

namespace cppbase
{

//! Compute factorial.
const int computeFactorial( const int integerNumber )
{
	if ( integerNumber < 0 )
	{
		std::ostringstream errorMessage;
		errorMessage << "ERROR: (" << integerNumber << "!) is undefined!" << std::endl;
		throw std::runtime_error( errorMessage.str( ) );
	}

	return ( integerNumber == 0 ) ? 1 : integerNumber * computeFactorial( integerNumber  - 1 );
}


} // namespace cppbase
