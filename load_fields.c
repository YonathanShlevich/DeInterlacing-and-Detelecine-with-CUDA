#include <stdlib.h>
#include <string.h>

#include "load_fields.h"

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

//produce the filename for a given frame
char * getFileName(int frame) {
    char *str;
    strcpy(str, "frames/0000.png");
    str[7] = ((frame / 1000) % 10) + '0';
    str[8] = ((frame / 100) % 10) + '0';
    str[9] = ((frame / 10) % 10) + '0';
    str[10] = ((frame / 1) % 10) + '0';

    return str;
}
struct video loadFields(unsigned int clipLength) {
    //setting up output struct
    struct video output;
    //setup vars
    int imageWidth, imageHeight, channels;

    //iterating through each frame in the clip
    for (int frame = 0; frame < clipLength; frame++) {
        //getting the file name for current frame
        char *inputFile = getFileName(frame);
        //load frame
        unsigned char *data = stbi_load(inputFile, &imageWidth, &imageHeight, &channels, 0);
        int rowLength = imageWidth * channels;

        for(int row = 0; row < imageHeight; row += 2) {
            for(int col = 0; col < rowLength; col++) {
                //output.evenFields[1][(row * rowLength) + col] = 1;
            }
        }

        //free temp memory
        free(inputFile);
        free(data);
    }

    return output;
}