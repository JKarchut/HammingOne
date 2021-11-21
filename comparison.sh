make
echo "Testing for 100000 vectors of 1000 length"
./fileGenerator 100000 1000 test.txt

echo "CPU"
CPU_START_TIME=$(date +%s%N | cut -b1-13)
./hemmingOneCpu test.txt > output_cpu.txt
CPU_END_TIME=$(date +%s%N | cut -b1-13)

echo "Running GPU"
GPU_START_TIME=$(date +%s%N | cut -b1-13)
./hemmingOneGpu test.txt > output_gpu.txt
GPU_END_TIME=$(date +%s%N | cut -b1-13)

echo `./verify output_cpu.txt output_gpu.txt` 

make clean
rm test.txt output_cpu.txt output_gpu.txt

echo "CPU calculations took $(($CPU_END_TIME - $CPU_START_TIME)) ms"
echo "GPU calculations took $(($GPU_END_TIME - $GPU_START_TIME)) ms"