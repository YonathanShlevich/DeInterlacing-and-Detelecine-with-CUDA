#include <stdio.h>

#include "load_fields.h"
#include "field_reduce_kernel.cu"

#define BLOCK_SIZE 512
#define clipLength 690

int main() {
    //Loading in all frames
    struct field * clip = loadFields(clipLength);

    for (int i = 0; i < getFieldSize(); i++) {
        if (clip[4].pixelData[i] != clip[6].pixelData[i]) {
            printf("Two fields are not identical at index %d\n", i);
        }
    }

    //calculating size of the output
    unsigned int out_elements = getFieldSize() / (BLOCK_SIZE<<1);
    if(getFieldSize() % (BLOCK_SIZE<<1)) out_elements++;

    cudaError_t cuda_ret;
    dim3 dim_grid, dim_block;

    for (int field = 0; field < 10/*clipLength * 2*/; field++) {
        //Initializing Host Variables --------------------------------------
        unsigned char * input_host = (unsigned char *)malloc(getFieldSize());
        input_host = clip[field].pixelData;
        unsigned int * output_host = (unsigned int *)malloc(out_elements * sizeof(unsigned int));

        //Allocating Device Variables --------------------------------------
        unsigned char * input_device;
        unsigned int * output_device;
        cuda_ret = cudaMalloc((void**)&input_device, getFieldSize());
        if(cuda_ret != cudaSuccess) printf("Unable to allocate device memory\n");

        cuda_ret = cudaMalloc((void**)&output_device, out_elements * sizeof(unsigned int));
        if(cuda_ret != cudaSuccess) printf("Unable to allocate device memory\n");

        cudaDeviceSynchronize();

        //Copy Host Variables to Device -----------------------------------
        cuda_ret = cudaMemcpy(input_device, input_host, getFieldSize(), cudaMemcpyHostToDevice);
        if(cuda_ret != cudaSuccess) printf("Unable to copy memory to the device\n");

        cuda_ret = cudaMemset(output_device, 0, out_elements * sizeof(unsigned int));
        if(cuda_ret != cudaSuccess) printf("Unable to set device memory\n");

        cudaDeviceSynchronize();

        //Launch Kernel ---------------------------------------------------
        dim_block.x = BLOCK_SIZE; dim_block.y = dim_block.z = 1;
        dim_grid.x = out_elements; dim_grid.y = dim_grid.z = 1;
        reduction<BLOCK_SIZE><<<dim_grid, dim_block>>>(output_device, input_device, getFieldSize());
        cuda_ret = cudaDeviceSynchronize();
        if(cuda_ret != cudaSuccess) printf("Unable to launch/execute kernel\n");

        //Copy Device Variables from Host ---------------------------------
        cuda_ret = cudaMemcpy(output_host, output_device, out_elements * sizeof(unsigned int), cudaMemcpyDeviceToHost);
        if(cuda_ret != cudaSuccess) printf("Unable to copy memory to host\n");

        cudaDeviceSynchronize();

        // //Accumulate Partial GPU Sums on Host  ----------------------------
        // for(int i = 1; i < out_elements; i++) {
        //     output_host[0] += output_host[i];
        // }
        // printf("GPU reduction for field %d: %u\n", field, output_host[0]);

        //CPU Calculation for Verification
        unsigned int result = 0;
        for(int i = 0; i < getFieldSize(); i++) {
            result += input_host[i];
        }
        printf("CPU reduction for field %d: %u\n", field, result);

        //Free Memory ------------------------------------------------------
        cudaFree(input_device); 
        cudaFree(output_device);
        free(input_host); 
        free(output_host);
    }
    return 0;
}