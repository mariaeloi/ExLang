#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdbool.h>

double main()
{
	if (!(true || false)) goto if1_skip;

	printf("%s\n", "ok");

	if1_skip:;

	return 0;
}
