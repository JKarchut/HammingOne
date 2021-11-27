#include <iostream>
#include <fstream>
#include <cstring>
#include <sys/time.h>

#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true)
{
   if (code != cudaSuccess) 
   {
      fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
      if (abort) exit(code);
   }
}

void parseNumber(int *arr, std::string number, int bitsPerInt)
{
    int bitPos = 0;
    int arrPos = 0;
    int pomValue = 0;
    for(int x = 0; x < number.length();x++)
    {
        if(bitsPerInt > bitPos)
        {
            pomValue += (int)(number[x] - '0') << bitPos;
            bitPos++;
        }
        else
        {
            arr[arrPos] = pomValue;
            arrPos++;
            bitPos = 0;
            pomValue = 0;
            x--;
        }
    }
    if(bitPos != 0)
    {
        arr[arrPos] = pomValue;
    }
}

__global__ void findPairs(int *arr, int n, int l)
{
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int diff, pom;
    for(int x = index + 1; x < n; x++)
    {
        diff = 0;
        for(int y = 0; y < l; y++)
        {
            pom = (arr[index * l + y]^arr[x * l + y]);
            if(pom != 0 && (pom & (pom - 1)) == 0)
            {
                diff++;
            }
            else if(pom > 0)
            {
                diff = 2;
            }
            if(diff > 1)
            {
                break;
            }
        }
        if(diff == 1)
        {
            printf("%d %d\n",index,x);
        }
    }
}

int32_t main(int argc, char** argv)
{
    std::ifstream data(argv[1]);
    std::ofstream measures(argv[2], std::ios::app);
    struct timeval begin, end;
    int n;
    int l;
    data >> n;
    data >> l;
    int bitsPerInt =  (sizeof(int) * 8) - 1;
    int taken = l / bitsPerInt;
    if(l % bitsPerInt != 0)
        taken++;
    int *arr;
    cudaMallocManaged(&arr, (long)n * sizeof(int) * taken);
    memset(arr,0,(long)taken * n * sizeof(int));
    std::string number;
    int arrPos = 0;
    while(data >> number)
    {
        parseNumber(&arr[(long)arrPos * taken], number, bitsPerInt);
        arrPos++;
    }
    int threadCount = 1024;
    int blockCount = (n / 1024) + 1;
    gpuErrchk(cudaDeviceSetLimit(cudaLimitPrintfFifoSize, (long long)1e15));
    gettimeofday(&begin, 0);
    findPairs<<<blockCount,threadCount>>>(arr,n,taken);
    gettimeofday(&end, 0);
    long seconds = end.tv_sec - begin.tv_sec;
    long microseconds = end.tv_usec - begin.tv_usec;
    double elapsed = seconds + microseconds*1e-6;
    measures <<"GPU " << elapsed << "s " << std::endl;
    gpuErrchk( cudaPeekAtLastError());
    gpuErrchk( cudaDeviceSynchronize());
    data.close();
    measures.close();
    cudaFree(arr);
    return 0;
}