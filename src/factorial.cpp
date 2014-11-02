/*    
 * Copyright (c) <year> <author> (<email>)
 * Distributed under the MIT License.
 * See accompanying file LICENSE.md or copy at http://opensource.org/licenses/MIT
 */

#include <stdexcept>

#include "CppProject/factorial.hpp"

namespace cpp_project
{

//! Compute factorial.
const int computeFactorial( const int integerNumber )
{
	if ( integerNumber < 0 )
	{
		throw std::runtime_error( "ERROR: Factorial of negative integer is undefined!" );
	}
	
	return ( integerNumber == 0 ) ? 1 : integerNumber * computeFactorial( integerNumber  - 1 );
}


} // namespace cpp_project
