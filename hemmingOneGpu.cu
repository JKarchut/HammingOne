#include <iostream>
#include <fstream>
#include <cstring>
void parseNumber(unsigned int *arr, std::string number, int bitsPerInt)
{
    int bitPos = 0;
    int arrPos = 0;
    unsigned int pomValue = 0;
    for(int x = 0; x < number.length();x++)
    {
        if(bitsPerInt > bitPos)
        {
            pomValue += (unsigned int)(number[x] - '0') << bitPos;
            bitPos++;
        }
        else
        {
            arr[arrPos] = pomValue;
            arrPos++;
            bitPos = 0;
            pomValue = 0;
        }
    }
    if(bitPos != 0)
    {
        arr[arrPos] = pomValue;
    }
}

__global__ void findPairs(unsigned int *arr, int n, int l)
{
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int diff, pom;
    for(int x = index + 1; x < n; x++)
    {
        diff = 0;
        for(int y = 0; y < l; y++)
        {
            pom = (arr[index * l + y]^arr[x * l + y]);
            if(pom > 0 && (pom & (pom - 1)) == 0)
                diff++;
            else if(pom > 0)
                diff = 2;
            if(diff > 1)
                break;
        }
        if(diff == 1)
        {
            printf("%d %d\n",id,x);
        }
    }
}

int32_t main(int argc, char** argv)
{
    std::ifstream data(argv[1]);
    int n;
    int l;
    data >> n;
    data >> l;
    int bitsPerInt =  sizeof(unsigned int) * 8 - 1;
    int taken = l / bitsPerInt;
    if(l % bitsPerInt != 0)
        taken++;
    unsigned int* arr;
    cudaMallocManaged(&arr, n * sizeof(unsigned int) * taken);
    memset(arr,0,taken * n * sizeof(unsigned int));
    std::string number;
    int arrPos = 0;
    while(data >> number)
    {
        parseNumber(&arr[arrPos * taken], number, bitsPerInt);
        arrPos++;
    }
    int threadCount = 1024;
    int blockCount = (n / 1024) + 1;
    cudaDeviceSetLimit(cudaLimitPrintfFifoSize, sizeof(unsigned int) * n * n);
    findPairs<<<blockCount,threadCount>>>(arr,n,taken);
    cudaDeviceSynchronize();
    data.close();
    cudaFree(arr);
    return 0;
}