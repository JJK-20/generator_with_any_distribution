#include "inverted_distribution_generator.h"

InvertedDistributionGenerator::InvertedDistributionGenerator()
{
	double arr[] = INTERVALS;
	this->number_of_elements_ = NUM_OF_ELEMENTS(arr, double);
	this->intervals_ = new double[number_of_elements_];
	std::copy(arr, arr + number_of_elements_, this->intervals_);

	this->seed_ = UnitGeneratorSeed();
	this->generator_ = CreateUnitGenerator();
}

InvertedDistributionGenerator::~InvertedDistributionGenerator()
{
	delete[] this->intervals_;
}

unsigned int InvertedDistributionGenerator::PrintRandomNumber()
{
	double random = generator_(seed_);
	
	int i = 0;
	while (random > intervals_[i++]);	//shortened version of looping and comparing
	std::cout << i << std::endl;
	return i;
}