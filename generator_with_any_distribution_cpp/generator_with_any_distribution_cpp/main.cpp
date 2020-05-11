#include <iostream>
#include "random_number_generator.h"
#include "inverted_distribution_generator.h"
#include "elimination_method_generator.h"

#define ITERATION_COUNTER_END 10000

int main()
{
	RandomNumberGenerator rng;

	InvertedDistributionGenerator id;
	rng.SetGeneratorType(&id);
	for(int iteration_counter = 0; iteration_counter < ITERATION_COUNTER_END; ++iteration_counter)
	{
		rng.Rand();
	}
	std::cout << "press enter to continue";
	std::cin.ignore();

	EliminationMethodGenerator em;
	rng.SetGeneratorType(&em);
	for (int iteration_counter = 0; iteration_counter < ITERATION_COUNTER_END; ++iteration_counter)
	{
		rng.Rand();
	}
	std::cout << "press enter to continue";
	std::cin.ignore();
}