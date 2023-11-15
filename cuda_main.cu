#include <stdio.h>

#include "load_fields.h"

#define BLOCK_SIZE 512
#define clipLength 690

int main()
{
    // Initialize host variables ---------------------------------------------

    printf("Initializing host variables\n");
    //Video field input to reduction algorithm
    struct field * input_host;
    struct field * input_device;

    //Unsigned long array output from reduction algorithm
    unsigned long * output_host;
    unsigned long * output_device;

    cudaError_t cuda_ret;
    dim3 dim_grid, dim_block;

    //initializing host input memory
    input_host = loadFields(clipLength);

    //allocating host output memory
    output_host = (unsigned long*)malloc(clipLength * 2 * sizeof(unsigned long));
    if(output_host == NULL) printf("Unable to allocate host");

    // Allocate device variables ----------------------------------------------

    printf("Allocating device variables\n");
    cuda_ret = cudaMalloc((void**)&input_device, clipLength * 2 * getFieldSize());
    if(cuda_ret != cudaSuccess) printf("Unable to allocate device memory");

    cuda_ret = cudaMalloc((void**)&output_device, clipLength * 2 * sizeof(unsigned long));
    if(cuda_ret != cudaSuccess) printf("Unable to allocate device memory");

    cudaDeviceSynchronize();

    // Copy host variables to device ------------------------------------------

    printf("Copying host variables to device\n");
    cuda_ret = cudaMemcpy(input_device, input_host, clipLength * 2 * getFieldSize(), cudaMemcpyHostToDevice);
    if(cuda_ret != cudaSuccess) printf("Unable to copy memory to the device");

    cuda_ret = cudaMemset(output_device, 0, clipLength * 2 * sizeof(unsigned long));
    if(cuda_ret != cudaSuccess) printf("Unable to set device memory");

    cudaDeviceSynchronize();

    // Launch kernel ----------------------------------------------------------

    // dim_block.x = BLOCK_SIZE; dim_block.y = dim_block.z = 1;
    // dim_grid.x = out_elements; dim_grid.y = dim_grid.z = 1;
    // //reduction<BLOCK_SIZE><<<dim_grid, dim_block>>>(out_d, in_d, in_elements);
    // cuda_ret = cudaDeviceSynchronize();
    // //fprintf(stderr,"GPUassert: %s\n", cudaGetLastError());
    // if(cuda_ret != cudaSuccess) printf("Unable to launch/execute kernel");


    // Copy device variables from host ----------------------------------------

    // cuda_ret = cudaMemcpy(out_h, out_d, out_elements * sizeof(float),
    //     cudaMemcpyDeviceToHost);
	// if(cuda_ret != cudaSuccess) printf("Unable to copy memory to host");

    // cudaDeviceSynchronize();

    // Free memory ------------------------------------------------------------

    printf("Freeing memory\n");
    cudaFree(input_device); cudaFree(output_device);
    free(input_host); free(output_host);

    return 0;
}

