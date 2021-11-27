all: hammingOneGpu hammingOneCpu fileGenerator verify

hammingOneCpu: hammingOneCpu.cpp
	g++ hammingOneCpu.cpp -o hammingOneCpu -std=gnu++0x

fileGenerator: fileGenerator.cpp
	g++ fileGenerator.cpp -o fileGenerator

verify : verify.cpp
	g++ verify.cpp -o verify

hammingOneGpu: hammingOneGpu.cu
	nvcc hammingOneGpu.cu -o hammingOneGpu

clean:
	rm fileGenerator hammingOneCpu verify hammingOneGpu