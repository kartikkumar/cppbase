/*
 * Copyright (c) <year> <author> (<email>)
 * Distributed under the MIT License.
 * See accompanying file LICENSE.md or copy at http://opensource.org/licenses/MIT
 */

#include <cstdlib>
#include <iostream>
#include <stdexcept>

#include "cppbase/factorial.hpp"

int main( const int numberOfInputs, const char* inputArguments[ ] )
{
	try
	{
		const int factorial = cppbase::computeFactorial( 10 );
		std::cout << "10! = " << factorial << std::endl;
	}
	catch( std::exception& error )
	{
		std::cout << error.what( ) << std::endl;
	}

	try
	{
		const int factorial = cppbase::computeFactorial( -5 );
		std::cout << "5! = " << factorial << std::endl;
	}
	catch( std::exception& error )
	{
		std::cout << error.what( ) << std::endl;
	}

	return EXIT_SUCCESS;
}
