#include <iostream>
#include <fstream>
#include <stdlib.h>
int main(int argc, char** argv)
{
    if(argc < 4)
        return 0;
    std::ofstream output(argv[3]);
    output << argv[1] << '\n' << argv[2] << '\n';
    int n = atoi(argv[1]);
    int l = atoi(argv[2]);
    int *arr = new int[n * l];
    int nrToSwitch;
    for(int x = 0; x < n ; x++)
    {
        if(x < n/2)
        {
            for(int y = 0; y < l; y++)
            {
                arr[x * l + y] = (rand() % 2);
                output<<arr[x * l + y];
            }
            output<<'\n';
        }
        else
        {
            nrToSwitch = rand() % l;
            for(int y = 0; y < l; y++)
            {
                if(y == nrToSwitch)
                {
                    output<<(1 - arr[(x - n/2) * l + y]);
                }
                else
                {
                    output<<arr[(x - n/2) * l + y];
                }
            }
            output<<'\n';
        }
    }
    output.close();
}