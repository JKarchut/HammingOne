#include <iostream>
#include <fstream>

#define int long long

void parseNumber(unsigned int *arr, std::string number, int bitNum)
{
    int bitPos = 0;
    int arrPos = 0;
    unsigned int pomValue = 0;
    for(int x = 0; x < number.length();x++)
    {
        if(bitNum > bitPos)
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
    int id = blockIdx.x * blockDim.x + threadIdx.x ;
    if (id >= n * n) return;
    int diff;
    for(int x = 0; x < n; x++)
    {
        if(x == id) continue;
        diff = 0;
        for(int y = 0; y < l; y++)
        {
            diff += arr[id * l + x]^arr[x * l +x];    
            if(diff > 1)
            {
                break;
            }  
        }
        if(diff <= 1)
        {
            printf("%d\n%d\n",id,x);
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
    int bitsPerInt =  sizeof(unsigned int) * 8;
    int taken = l / bitsPerInt;
    if(l % bitsPerInt != 0)
        taken++;
    unsigned int* arr = new unsigned int[n * taken];
    std::string number;
    int arrPos = 0;
    while(data >> number)
    {
        parseNumber(&arr[taken * arrPos], number, bitsPerInt);
        arrPos++;
    }

    unsigned int* arr_d;
    cudaMalloc(&arr_d, n * taken * sizeof(unsigned int));
    cudaMemcpy(arr_d,arr, n * taken, cudaMemcpyHostToDevice);
    int threadCount = 1024;
    int blockSize = n / threadCount + 1;
    findPairs<<<blockSize,threadCount>>>(arr_d,n,taken);
    data.close();
    cudaFree(arr_d);
    delete[] arr;
}