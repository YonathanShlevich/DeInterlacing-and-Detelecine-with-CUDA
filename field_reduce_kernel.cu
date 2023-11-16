#include <stdlib.h>

template <int BLOCK_SIZE>
__global__ void reduction(unsigned int * out, unsigned char * in, unsigned size)
{
    /********************************************************************
    Load a segment of the input vector into shared memory
    Traverse the reduction tree
    Write the computed sum to the output vector at the correct index
    ********************************************************************/

    // Shared memory for each block
    __shared__ unsigned int sdata[BLOCK_SIZE];

    unsigned int tid = threadIdx.x;
    unsigned int i = blockIdx.x * (BLOCK_SIZE << 1) + threadIdx.x;

    // Initialize shared memory with input data
    sdata[tid] = 0;
    if (i < size)
        sdata[tid] = in[i];
    if (i + BLOCK_SIZE < size)
        sdata[tid] += in[i + BLOCK_SIZE];

    // Perform the reduction in shared memory
    for (unsigned int stride = BLOCK_SIZE >> 1; stride > 0; stride >>= 1)
    {
        __syncthreads();  // Synchronize within the block

        if (tid < stride)
        {
            sdata[tid] += sdata[tid + stride];
        }
    }

    // Write the result to global memory
    if (tid == 0)
    {
        out[blockIdx.x] = sdata[0];
    }
}