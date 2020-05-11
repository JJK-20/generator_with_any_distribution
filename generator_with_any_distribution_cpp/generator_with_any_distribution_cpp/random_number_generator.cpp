#include "random_number_generator.h"

unsigned int RandomNumberGenerator::Rand()
{
	return this->generator_type_->PrintRandomNumber();
}

void RandomNumberGenerator::SetGeneratorType(AbstractGeneratorType* generator_type)
{
	this->generator_type_ = generator_type;
}
