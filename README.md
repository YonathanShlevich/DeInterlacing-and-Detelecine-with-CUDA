# DeInterlacing-and-Detelecine-with-CUDA
Using CUDA C to deinterlace and detelecine video inputs

## Possible Algorithm:
59.97 interlaced source -> pull video fields into a struct (Pixel) -> Compare the fields in sets of 3s and 2s to see which fields to throw away (in the 3’s, throw out the last half field) -> deinterlace each set of 2 fields -> write that to an output file at the correct FPS (24fps) 

