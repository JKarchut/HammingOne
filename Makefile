all: hemmingOneGpu hemmingOneCpu fileGenerator verify

hemmingOneCpu: hemmingOneCpu.cpp
	g++ hemmingOneCpu.cpp -o hemmingOneCpu

fileGenerator: fileGenerator.cpp
	g++ fileGenerator.cpp -o fileGenerator

verify : verify.cpp
	g++ verify.cpp -o verify

hemmingOneGpu: hemmingOneGpu.cu
	nvcc hemmingOneGpu.cu -o hemmingOneGpu

clean:
	rm fileGenerator hemmingOneCpu verfiy hemmingOneGpu