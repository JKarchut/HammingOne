#include <iostream>
#include <fstream>

void parseNumber(unsigned int *arr, std::string number)
{
    int bitNum = sizeof(unsigned int) * 8;
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

__global__ void findPairs(unsigned int **arr, int n, int l)
{
    int id = blockIdx.x;
    int comp1 = id / n;
    int comp2 = id - comp1 * n;
    int diff = 0;
    for(int x = 0; x < l; x++)
    {
        diff += arr[comp1][x]^arr[comp2][x];
        if(diff > 1)
        {
            break;
        }
    }
    if(diff <= 1)
    {
        printf("%d\n%d\n",comp1,comp2);
    }
}

int main(int argc, char** argv)
{
    std::ifstream data(argv[1]);
    int n;
    int l;
    data >> n;
    data >> l;
    int taken = l / (sizeof(unsigned int) * 8);
    if(l % (sizeof(unsigned int) * 8) != 0)
        taken++;
    unsigned int** arr;
    cudaMallocManaged(&arr, n * sizeof(unsigned int*));
    for(int x = 0 ; x < n; x++)
    {
        cudaMallocManaged(&arr[x],taken);
    }
    std::string number;
    int arrPos = 0;
    while(data >> number)
    {
        parseNumber(arr[arrPos], number);
        arrPos++;
    }
    dim3 blockSize(n*n,1,1);
    findPairs<<<blockSize,1>>>(arr,n,taken);
    data.close();
    for(int x = 0; x < n; x++)
    {
        delete[] arr[x];
    }
    delete[] arr;
}