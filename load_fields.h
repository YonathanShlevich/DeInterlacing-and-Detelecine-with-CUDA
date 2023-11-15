struct field {
    char *pixelData; //Pixel data for each field
};

//returns char array containing file name of the given frame
char * getFileName(int frame);

//loads the even and odd fields from the given frame
struct field * loadFields(unsigned int clipLength);