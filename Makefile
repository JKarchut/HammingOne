all: hemmingOneGpu hemmingOneCpu fileGenerator verfiy

hemmingOneCpu: hemmingOneCpu.cpp
	g++ hemmingOneCpu.cpp -o hemmingOneCpu

fileGenerator: fileGenerator.cpp
	g++ fileGenerator.cpp -o fileGenerator

verfiy : verfiy.cpp
	g++ verfiy.cpp -o verfiy

hemmingOneGpu: hemmingOneGpu.cu
	nvcc hemmingOneGpu.cu -o hemmingOneGpu

clean:
	rm fileGenerator hemmingOneCpu verfiy hemmingOneGpu