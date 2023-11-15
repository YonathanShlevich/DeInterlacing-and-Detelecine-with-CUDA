#include <stdio.h>
#include <stdlib.h>
#include "load_fields.h"


int main() {
    //setting up variables
    char *fileName = getFileName(67);
    printf("File Name: %s\n", fileName);
    free(fileName);
    unsigned int clipLength = 690;

    struct field * clip = loadFields(clipLength);

    return 0;
}

