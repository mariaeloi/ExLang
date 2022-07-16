#include <stdio.h>
#include <math.h>

double main(  )
{
	double  numero;
	scanf("%lf", &numero ) ;
	if (!(numero > 0)) goto skip_if;
	{
		printf("%f", numero ) ;
	}
	skip_if:
;
	return 1.20;
}
