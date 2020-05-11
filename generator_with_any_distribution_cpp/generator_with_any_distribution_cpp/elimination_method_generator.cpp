#include "elimination_method_generator.h"

EliminationMethodGenerator::EliminationMethodGenerator()
{
	srand(time(NULL));
}

unsigned int EliminationMethodGenerator::PrintRandomNumber()
{
	int U1 = rand() % (b - a + 1) + a;
	int U2 = rand() % d;
	if (U2 < A*U1 + B)
		std::cout << U1 << " " << U2 << std::endl;
	else
		std::cout << "In normal generator we reject this values and we should draw again " << U1 << " " << U2 << std::endl;
	return U1;
}
