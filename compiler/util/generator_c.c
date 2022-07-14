#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

void create_file(char* filename, char* program)  {
    FILE *file_output;
    
    file_output = fopen(filename, "w");

    if (file_output == NULL) {
        printf("error!");
        exit(0);
    }

    fprintf(file_output, "%s\n", "#include <stdio.h>");

    
    fclose(file_output);
}