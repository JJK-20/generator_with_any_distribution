#pragma once

#include"abstract_generator_type.h"

class RandomNumberGenerator
{
public:
	unsigned int Rand();
	void SetGeneratorType(AbstractGeneratorType* generator_type);
private:
	AbstractGeneratorType* generator_type_;
};