#include <stdio.h>
#include <math.h>

double main(  )
{
	double  numero;
	numero = 1;
	main_while:
	if (!(numero >= 0)) goto skip_while;
	{
	scanf("%lf", &numero ) ;
	if (!(numero < 0)) goto skip_if;
	{
	printf("%f", numero ) ;
	}
	skip_if:
;
	}
	goto main_while;
	skip_while:
;
	return 0;
}
