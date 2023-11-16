NVCC        = nvcc
NVCC_FLAGS  = -O3 -I/usr/local/cuda/include -diag-suppress 550
LD_FLAGS    = -lcudart -L/usr/local/cuda/lib64
EXE         = program
OBJ         = cuda_main.o load_fields.o

default: $(EXE)

cuda_main.o: cuda_main.cu load_fields.h
	$(NVCC) -c -o $@ cuda_main.cu $(NVCC_FLAGS)

load_fields.o: load_fields.cu load_fields.h
	$(NVCC) -c -o $@ load_fields.cu $(NVCC_FLAGS)

$(EXE): $(OBJ)
	$(NVCC) $(OBJ) -o $(EXE) $(LD_FLAGS)

main: main.o load_fields.o
	$(CC) -o program main.o load_fields.o -lm

clean: 
	rm -rf *.o $(EXE)

