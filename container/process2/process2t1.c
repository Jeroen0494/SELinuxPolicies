#include <stdio.h>
int main() {
	FILE *fp;
	char text[20];
	printf("Please type something to continue... \n");
	scanf("%s", text);
	fp = fopen("/opt/container/process2/data/process2_direct.txt","w");
	if(fp == 0) {
		printf("Error! \n");
		return 1;
	}
 
	fprintf(fp,"This file was created by process 2");
	fclose(fp);
	return 0;
}
