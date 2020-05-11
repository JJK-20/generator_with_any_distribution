#pragma once

#include "abstract_generator_type.h"
#include<stdlib.h>
#include<iostream>
#include<time.h>

#define a 30 
#define b 100
#define d 50
#define A 2
#define B -20

class EliminationMethodGenerator : public AbstractGeneratorType
{
public:
	EliminationMethodGenerator();
	unsigned int PrintRandomNumber();
};