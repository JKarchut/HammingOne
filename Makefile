all: hemmingOneGpu hemmingOneCpu fileGenerator

hemmingOneCpu: hemmingOneCpu.cpp
	g++ hemmingOneCpu.cpp -o hemmingOneCpu

fileGenerator: fileGenerator.cpp
	g++ fileGenerator.cpp -o fileGenerator

hemmingOneGpu: hemmingOneGpu.cu
	nvcc hemmingOneGpu.cu -o hemmingOneGpu

clean:
	rm fileGenerator hemmingOneCpu