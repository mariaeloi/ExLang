#include <stdio.h>
#include <math.h>

double main (  
)
{
	double  a ;    
	a = 0;    
	double  i_1 , i_2 , i_3 , i_4 ;    
	i_1 = 0;    
	i_2 = 0;    
	i_3 = 0;    
	i_4 = 0;    
	main_while1_if2_skip_if3_skip_if4_skip_if5_skip_skip:
	if (!(a >= 0)) goto main_while1_if2_skip_if3_skip_if4_skip_if5_skip_skip;
	{
	scanf("%lf", &a );   
	if (!(a >= 0 && a <= 25)) goto main_while1_if2_skip;
	{
i_1 = i_1 + 1;  	}
	main_while1_if2_skip:
  
	if (!(a >= 26 && a <= 50)) goto main_while1_if2_skip_if3_skip;
	{
i_2 = i_2 + 1;  	}
	main_while1_if2_skip_if3_skip:
  
	if (!(a >= 51 && a <= 75)) goto main_while1_if2_skip_if3_skip_if4_skip;
	{
i_3 = i_3 + 1;  	}
	main_while1_if2_skip_if3_skip_if4_skip:
  
if (!(a >= 76 && a <= 100)) goto main_while1_if2_skip_if3_skip_if4_skip_if5_skip;
	{
i_4 = i_4 + 1;  	}
	main_while1_if2_skip_if3_skip_if4_skip_if5_skip:
	}
	goto main_while1_if2_skip_if3_skip_if4_skip_if5_skip_skip;
	main_while1_if2_skip_if3_skip_if4_skip_if5_skip_skip:
  
	printf("%f" , i_1 );
  
	printf("%f" , i_2 );
  
	printf("%f" , i_3 );
  
	printf("%f" , i_4 );
  
return 0 ;  }
