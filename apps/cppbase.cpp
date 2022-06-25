/*
 * Copyright (c) 2014-2022 Kartik Kumar (me@kartikkumar.com)
 * Distributed under the MIT License.
 * See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT
 */

#include <cstdlib>
#include <iostream>

#include "cppbase/cppbaseAll.hpp"

int main(const int numberOfInputs, const char* inputArguments[])
{
	const int factorial = cppbase::computeFactorial(10);
	std::cout << "10! = " << factorial << std::endl;
    std::cout << "Hello!" << std::endl;
	return EXIT_SUCCESS;
}
