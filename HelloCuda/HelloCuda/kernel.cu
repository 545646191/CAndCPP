#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>

using namespace std;

__device__ int add_one(int a) {

	return a + 1;
}

__global__ void show(int *a) {

	for (int i = 0; i < 10; i++) {

		//a[i] = add_one(a[i]);
		printf(" %d", a[i]);
	}
	printf("\n");
}

__global__ void changeValue(int *a) {

	for (int i = 0; i < 10; i++) {

		a[i] = 100;
	}
}

int main() {

	int cpu_int[10] = {10, 10, 10, 10, 10, 10, 10, 10, 10, 10};
	int *gpu_int;

	//��GPU�Ϸ���ռ�
	cudaMalloc((void**)&gpu_int, 10 * sizeof(int));
	show << <1, 1 >> > (gpu_int);

	//��ʼ����ֵ
	cudaMemset(gpu_int, 0, 10 * sizeof(int));
	show<< <1, 1 >> > (gpu_int);

	//��cpu_int��ֵ��gpu_int
	cudaMemcpy(gpu_int, cpu_int, 10 * sizeof(int), cudaMemcpyHostToDevice);
	show << <1, 1 >> > (gpu_int);

	//�ı�gpu_int��ֵ
	changeValue << <1, 1 >> >(gpu_int);
	show << <1, 1 >> > (gpu_int);


	cudaMemcpy(cpu_int, gpu_int, 10 * sizeof(int), cudaMemcpyDeviceToHost);
	printf("----------�����ķָ���----------");
	for (int i = 0; i < 10; i++) {


		printf("%d", cpu_int[i]);
	}



	cudaFree(gpu_int);


	getchar();
	return 0;
}