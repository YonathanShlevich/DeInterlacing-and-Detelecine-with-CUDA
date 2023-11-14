struct field
{
    unsigned char *data; //Pixel data for one field
};

struct video
{
    struct field *evenFields;
    struct field *oddFields;
};

//returns char array containing file name of the given frame
char * getFileName(int frame);

//loads the even and odd fields from the given frame
struct video loadFields(unsigned int clipLength);