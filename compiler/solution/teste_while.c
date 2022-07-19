#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdbool.h>

double main()
{
	double numero;
	numero = 1;
	while2:
	if (!(numero >= 0)) goto while2_skip;

	scanf("%lf", &numero);
	if (!(numero < 0)) goto if1_skip;

	printf("%f\n", numero);

	if1_skip:;

	goto while2;
	while2_skip:

	return 0;
}
