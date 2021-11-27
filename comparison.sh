echo "" >> time.txt
echo "--- TEST ---" >> time.txt

make
echo "dataset 100k vectors of 1000 long" >> time.txt

echo "--- CPU ---" >> time.txt
echo "CPU"
CPU_START_TIME=$(date +%s%N | cut -b1-13)
./hammingOneCpu test.txt > output_cpu.txt time.txt
CPU_END_TIME=$(date +%s%N | cut -b1-13)
echo "CPU total $(($CPU_END_TIME - $CPU_START_TIME)) ms" >> time.txt

echo "--- GPU ---" >> time.txt
echo "GPU"
GPU_START_TIME=$(date +%s%N | cut -b1-13)
./hammingOneGpu test.txt > output_gpu.txt time.txt
GPU_END_TIME=$(date +%s%N | cut -b1-13)
echo "GPU total $(($GPU_END_TIME - $GPU_START_TIME)) ms" >> time.txt

echo `./verify output_cpu.txt output_gpu.txt` >> time.txt

make clean

