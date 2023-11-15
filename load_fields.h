struct field {
    char *pixelData; //Pixel data for each field
};

//returns char array containing file name of the given frame
char * getFileName(int frame);

//returns the size in bytes of a field
size_t getFieldSize();

//loads the even and odd fields from the given frame
struct field * loadFields(unsigned int clipLength);