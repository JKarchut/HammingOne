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
    for(int x = 0; x<n ; x++)
    {
        for(int y = 0; y < l; y++)
        {
            output<< rand() % 2;
        }
        output << '\n';
    }
    output.close();
}