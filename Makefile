all: hemmingOneGpu hemmingOneCpu fileGenerator verify brute

hemmingOneCpu: hemmingOneCpu.cpp
	g++ hemmingOneCpu.cpp -o hemmingOneCpu -std=gnu++0x

fileGenerator: fileGenerator.cpp
	g++ fileGenerator.cpp -o fileGenerator

verify : verify.cpp
	g++ verify.cpp -o verify

brute: brute.cpp
	g++ brute.cpp -o brute

hemmingOneGpu: hemmingOneGpu.cu
	nvcc hemmingOneGpu.cu -o hemmingOneGpu

clean:
	rm fileGenerator hemmingOneCpu verify hemmingOneGpu