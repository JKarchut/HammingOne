#include <iostream>
#include <fstream>
#include <cstring>
 
void parseNumber(unsigned int *arr, std::string number)
{
    for(int x = 0; x < number.length();x++)
    {
        arr[x] = (number[x] - '0');
    }
}


__global__ void findPairs(  int *arr, int n, int l)
{
    int id = blockIdx.x * blockDim.x + threadIdx.x;
    int diff, pom;
    for(int x = id + 1; x < n; x++)
    {
        diff = 0;
        for(int y = 0; y < l; y++)
        {
           if(arr[x * l + y] != arr[id * l + y])
                diff++;
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
    unsigned int* arr = new unsigned int[n * l];
    memset(arr,0,n * l * sizeof(unsigned int));
    std::string number;
    int arrPos = 0;

    while(data >> number)
    {
        parseNumber(&arr[arrPos * l], number);
        arrPos++;
    }
    int* arr_d;
    cudaMalloc(&arr_d, n * l * sizeof(unsigned int));
    cudaMemcpy(arr_d,arr, n * l * sizeof(unsigned int), cudaMemcpyHostToDevice);
    int threadCount = 1024;
    int blockSize = n / threadCount + 1;
    findPairs<<<blocks,threadCount>>>(arr_d,n,l);
    data.close();
    cudaFree(arr_d);
    delete[] arr;
}