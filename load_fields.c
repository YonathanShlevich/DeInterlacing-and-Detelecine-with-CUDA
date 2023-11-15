#include <stdlib.h>
#include <string.h>

#include "load_fields.h"

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

//produce the filename for a given frame
char * getFileName(int frame) {
    //length of filename
    size_t length = 16 * sizeof(char);
    //malloc output string
    char *output = malloc(16*sizeof(char));
    //base string
    char str[] = "frames/0000.png";
    //converting frame number to chars
    str[7] = ((frame / 1000) % 10) + '0';
    str[8] = ((frame / 100) % 10) + '0';
    str[9] = ((frame / 10) % 10) + '0';
    str[10] = ((frame / 1) % 10) + '0';

    //string copy to output
    strncpy(output, str, length);
    return output;
}

struct field * loadFields(unsigned int clipLength) {
    //checking video height, width, and channels per pixel
    int imageHeight, imageWidth, channels, info;
    info = stbi_info(getFileName(0), &imageWidth, &imageHeight, &channels);
    
    //determining the size of the output
    size_t fieldSize = (imageHeight / 2) * imageWidth * channels * sizeof(char);
    int rowLength = imageWidth * channels;

    //setting up output
    struct field *output = malloc(clipLength * 2 * fieldSize);
    for(int i = 0; i < clipLength * 2; i++) {
        output[i].pixelData = malloc(fieldSize);
    }

    //iterating through each frame in the clip
    for (int frame = 0; frame < clipLength; frame++) {
        //load frame
        unsigned char *data = stbi_load(getFileName(frame), &imageWidth, &imageHeight, &channels, 0);
        //iterating through image rows and cols
        for(int row = 0; row < imageHeight; row += 2) {
            for(int col = 0; col < rowLength; col++) {
                output[frame * 2].pixelData[((row / 2) * rowLength) + col] = data[(row * rowLength) + col];
            }
        }
        //free temp memory
        free(data);
    }

    return output;
}