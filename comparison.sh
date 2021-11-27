make
echo "Testing for 100000 vectors of 1000 length"
./fileGenerator 100000 1000 test.txt

echo "CPU"
CPU_START_TIME=$(date +%s%N | cut -b1-13)
./hemmingOneCpu test.txt > output_cpu.txt time.txt
CPU_END_TIME=$(date +%s%N | cut -b1-13)

echo "Running GPU"
GPU_START_TIME=$(date +%s%N | cut -b1-13)
./hemmingOneGpu test.txt > output_gpu.txt time.txt
GPU_END_TIME=$(date +%s%N | cut -b1-13)

echo `./verify output_cpu.txt output_gpu.txt` >> time.txt

make clean

echo "CPU calculations took $(($CPU_END_TIME - $CPU_START_TIME)) in total ms" >> time.txt
echo "GPU calculations took $(($GPU_END_TIME - $GPU_START_TIME)) in total ms" >> time.txt