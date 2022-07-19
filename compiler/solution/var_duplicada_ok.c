#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdbool.h>

double a, b;
double soma(double a, double x)
{
	double b;
	b = 1;
	return a + x;
}
double main(double b)
{
	a = 2;
	b = 3;
	printf("%f\n", soma(a, b));
	return 0;
}
