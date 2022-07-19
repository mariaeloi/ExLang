#include <stdio.h>
#include <math.h>

double  i_1 , i_2 , i_3 , i_4 ;  ;
void  integrar ( double  a)
{
	if (!(a >= 0 && a <= 25)) goto if1_skip;

i_1 = i_1 + 1;  

	if1_skip:
  
	if (!(a >= 26 && a <= 50)) goto if2_skip;

i_2 = i_2 + 1;  

	if2_skip:
  
	if (!(a >= 51 && a <= 75)) goto if3_skip;

i_3 = i_3 + 1;  

	if3_skip:
  
if (!(a >= 76 && a <= 100)) goto if4_skip;

i_4 = i_4 + 1;  

	if4_skip:

}
double main (    )
{
	double  a ;    
	a = 0;    
	i_1 = 0;    
	i_2 = 0;    
	i_3 = 0;    
	i_4 = 0;    
	while5:
	if (!(a >= 0)) goto while5_skip;

	scanf("%lf", &a );   
integrar ( a ) ;

	goto while5;
	while5_skip:
  
	printf("%f" , i_1 );
  
	printf("%f" , i_2 );
  
	printf("%f" , i_3 );
  
	printf("%f" , i_4 );
  
return 0 ;  
}
