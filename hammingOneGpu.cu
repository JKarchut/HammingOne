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
    long index = blockIdx.x * blockDim.x + threadIdx.x;
    int diff, pom;
    for(long x = index + 1; x < n; x++)
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
            printf("%ld %ld\n",index,x);
        }
    }
}

double GetElapsed(struct timeval begin, struct timeval end)
{
    long seconds = end.tv_sec - begin.tv_sec;
    long microseconds = end.tv_usec - begin.tv_usec;
    return (seconds + microseconds*1e-6) * 1000;
}

int32_t main(int argc, char** argv)
{
    std::ifstream data(argv[1]);
    std::ofstream measures(argv[2], std::ios::app);
    if(arc < 3) return -1;
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
    arr = new int[taken * n];
    memset(arr,0,(long)taken * n * sizeof(int));
    std::string number;
    int arrPos = 0;
    gettimeofday(&begin, 0);
    while(data >> number)
    {
        parseNumber(&arr[(long)arrPos * taken], number, bitsPerInt);
        arrPos++;
    }
    gettimeofday(&end, 0);
    
    measures <<"GPU read data: " << GetElapsed(begin,end) << "ms " << std::endl;
    
    int threadCount = 1024;
    int blockCount = (n / 1024) + 1;
    int *arr_d;
    gettimeofday(&begin, 0);
    gpuErrchk(cudaMalloc(&arr_d, (long)taken * n * sizeof(int)));
    gpuErrchk(cudaMemcpy(arr_d, arr, (long)taken * n * sizeof(int), cudaMemcpyHostToDevice));
    gettimeofday(&end, 0);
    measures <<"GPU alloc and copy to device: " << GetElapsed(begin,end) << "ms " << std::endl;
    
    gpuErrchk(cudaDeviceSetLimit(cudaLimitPrintfFifoSize, (long long)1e15));
    gettimeofday(&begin, 0);
    findPairs<<<blockCount,threadCount>>>(arr_d,n,taken);
    gpuErrchk( cudaPeekAtLastError());
    gpuErrchk( cudaDeviceSynchronize());
    gettimeofday(&end, 0);
    measures <<"GPU algorithm: " << GetElapsed(begin,end) << "ms " << std::endl;
    data.close();
    measures.close();
    cudaFree(arr_d);
    delete[] arr;
    return 0;
}