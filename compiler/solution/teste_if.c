#include <stdio.h>
#include <math.h>

double main(  )
{
	double  numero;
	scanf("%lf", &numero ) ;
	if (!(numero > 0)) goto main_if1_skip;
	{
	printf("%f", numero ) ;
	}
	main_if1_skip:
;
	return 1.20;
}
