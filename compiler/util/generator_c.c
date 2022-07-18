#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

void create_file(char* filename, char* program)  {
    FILE *file_output;
    
    char filename_[100];
    sprintf(filename_, "solution/%s.c", filename);
    file_output = fopen(filename_, "w");

    if (file_output == NULL) {
        printf("error!");
        exit(0);
    }

    fprintf(file_output, "%s\n", "#include <stdio.h>");
    fprintf(file_output, "%s\n", "#include <math.h>");
    fprintf(file_output, "\n");

    fprintf(file_output, "%s", program);

    fclose(file_output);
}


char* concate(int quantity, ...) {
    va_list elements;
    va_start(elements, quantity);

    int result_length = 0;    
    for (int i = 0; i < quantity; ++i)
      result_length += strlen(va_arg(elements, char*));

    va_end(elements);

    char* result = malloc(sizeof *result +(sizeof(char) * result_length));

    va_start(elements, quantity);
    int delimiter = 0;
    for (int i = 0; i < quantity; ++i) {
      char* source = va_arg(elements, char*);
      strcpy(result + delimiter, source);
      delimiter += strlen(source);
    }
    
    return result;
  }