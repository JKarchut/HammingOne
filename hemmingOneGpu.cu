#include <iostream>
#include <fstream>
#include <cstring>
 
void parseNumber(  int *arr, std::string number, int bitsPerInt)
{
    int bitPos = 0;
    int arrPos = 0;
    int pomValue = 0;
    for(int x = 0; x < number.length();x++)
    {
        if(bitPos < bitsPerInt)
        {
            pomValue = (pomValue * 2) + ((int)(number[x] - '0'));
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

__global__ void findPairs(  int *arr, int n, int l)
{
    int id = blockIdx.x * 1024 + threadIdx.x;
    int diff, pom;
    for(int x = id + 1; x < n; x++)
    {
        diff = 0;
        for(int y = 0; y < l; y++)
        {
            pom = 0;
            pom = (arr[(id * l) + y]^arr[(x * l) + y]);    
            while(pom != 0)
            {
                diff += (pom & 1);
                pom = (pom >> 1);
                if(diff > 1)
                    break;
            }
            if(diff > 1)
                break;
        }
        if(diff == 1)
        {
            printf("%d %d\n",id,x);
        }
    }
    
}

int main(int argc, char** argv)
{
    std::ifstream data(argv[1]);
    int n;
    int l;
    data >> n;
    data >> l;
    int bitsPerInt =  15;
    int taken = l / bitsPerInt;
    if(l % bitsPerInt != 0)
        taken++;
    int* arr = new   int[n * taken];
    memset(arr,0,taken * n * sizeof(int));
    std::string number;
    int arrPos = 0;
    while(data >> number)
    {
        parseNumber(&arr[taken * arrPos], number, bitsPerInt);
        arrPos++;
    }
    printf("%d %d\n",n,taken);
    int* arr_d;
    cudaMalloc(&arr_d, n * taken * sizeof(int));
    cudaMemcpy(arr_d,arr, n * taken * sizeof(int), cudaMemcpyHostToDevice);
    int threadCount = 1024;
    int blockSize = (n / threadCount) + 1;
    findPairs<<<blockSize,threadCount>>>(arr_d,n,taken);
    cudaDeviceSynchronize();
    data.close();
    cudaFree(arr_d);
    delete[] arr;
}