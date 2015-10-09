#include <stdio.h>
int main() {
	FILE *fp;
	fp = fopen("/opt/container/process2/data/process1_direct.txt","w");
	if(fp == 0) {
		printf("Error! \n");
		return 1;
	}
 
	fprintf(fp,"This file was created by process 1");
	fclose(fp);
	return 0;
}
