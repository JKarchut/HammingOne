all: hemmingOneGpu hemmingOneCpu fileGenerator verify

hemmingOneCpu: hemmingOneCpu.cpp
	g++ hemmingOneCpu.cpp -o hemmingOneCpu -std=gnu++0x

fileGenerator: fileGenerator.cpp
	g++ fileGenerator.cpp -o fileGenerator

verify : verify.cpp
	g++ verify.cpp -o verify

hemmingOneGpu: hemmingOneGpu.cu
	nvcc hemmingOneGpu.cu -o hemmingOneGpu

clean:
	rm fileGenerator hemmingOneCpu verify hemmingOneGpu