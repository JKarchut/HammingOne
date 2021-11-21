#include <iostream>
#include <fstream>

int main(int argc, char** argv)
{
    if(argc < 3)
        return 0;
    std::ofstream output(argv[2]);
    output << argv[0] << '\n' << argv[1] << '\n';
    int n = std::atoi(argv[0]);
    int l = std::atoi(argv[1]);
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