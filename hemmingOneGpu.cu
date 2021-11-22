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
            pomValue = pomValue * 2 + ((  int)(number[x] - '0'));
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
    if (id >= n) return;
    int diff, pom;
    for(int x = id + 1; x < n; x++)
    {
        diff = 0;
        for(int y = 0; y < l; y++)
        {
            pom = (arr[id * l + y]^arr[x * l + y]);    
            while(pom != 0)
            {
                diff += (pom & 1);
                pom = (pom >> 1);
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
int_ceil(double variable) {

int new_variable = (int)variable;

if ((double)new_variable == variable) return new_variable;

else return new_variable + 1;

}

int32_t main(int argc, char** argv)
{
    std::ifstream data(argv[1]);
    int n;
    int l;
    data >> n;
    data >> l;
    int bitsPerInt =  15;
    // int taken = l / bitsPerInt;
    // if(l % bitsPerInt != 0)
    //     taken++;
int taken = _ceil((double)l / bitsPerInt);
      int* arr = new   int[n * taken];
    memset(arr,0,taken * n * sizeof(  int));
    std::string number;
    int arrPos = 0;
    while(data >> number)
    {
        parseNumber(&arr[taken * arrPos], number, bitsPerInt);
        arrPos++;
    }

    int* arr_d;
    cudaMalloc(&arr_d, n * taken * sizeof(  int));
    cudaMemcpy(arr_d,arr, n * taken * sizeof(  int), cudaMemcpyHostToDevice);
    int threadCount = 1024;
    // int blockSize = n / threadCount + 1;
    int blocks = _ceil((double)n / threadCount);
    findPairs<<<blocks,threadCount>>>(arr_d,n,taken);
    data.close();
    cudaFree(arr_d);
    delete[] arr;
}