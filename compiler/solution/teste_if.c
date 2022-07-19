#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdbool.h>

double main()
{
	double a;
	scanf("%lf", &a);
	if (!(a > 0)) goto if1_skip;

	printf("%f\n", a);

	if1_skip:;

	return 0;
}
