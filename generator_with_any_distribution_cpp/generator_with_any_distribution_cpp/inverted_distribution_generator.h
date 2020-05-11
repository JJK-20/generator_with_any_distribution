#pragma once

#include "abstract_generator_type.h"
#include<algorithm>
#include<iostream>
#include"utility.h"

#define INTERVALS { 0.2,0.6,0.9,1.0 }

class InvertedDistributionGenerator : public AbstractGeneratorType
{
public:
	InvertedDistributionGenerator();
	~InvertedDistributionGenerator();
	unsigned int PrintRandomNumber();
private:
	double *intervals_;
	int number_of_elements_;
	std::mt19937 seed_;
	std::uniform_real_distribution<double> generator_;
};
