#include <stdio.h>
#include <math.h>

double main (    )
{
	double  a ;    
	scanf("%lf", &a );   
	if (!(a > 0)) goto main_if1_skip;
	{
printf("%f" , a );
	}
	main_if1_skip:
  
return 0 ;  
}
