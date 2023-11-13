#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

int main() {

    //setting up variables
    char inputFile[] = "0000.png";
    int imageWidth, imageHeight, channels, info;
    //unsigned int bufferSize = imageHeight * imageHeight * 3;

    //loading png info
    info = stbi_info(inputFile, &imageWidth, &imageHeight, &channels);


    printf("Image Height: %d\n", imageHeight);
    return 0;
}

