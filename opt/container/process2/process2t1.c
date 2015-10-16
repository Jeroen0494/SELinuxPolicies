#include <stdio.h>

int main() {
	FILE *fp;
	int option;
	size_t len;
	char *buf = NULL;
	
	printf("This program has two function. Please specify the option \n");
	printf("Choose '1' for writing to the data folder \n");
	printf("Choose '2' for reading from the etc folder \n");
	printf("Your input: ");
	
	option = getchar();
	
	if(option == '1') {
		fp = fopen("/opt/container/process2/data/process2_direct.txt","w");
		if(!fp) {
			printf("Error! \n");
			return 1;
		}
	 
		fprintf(fp,"This file was created by process 2");
	}

	if(option == '2') {
		fp = fopen("/opt/container/process2/etc/boolean.config","rt");
		if(!fp) {
			printf("Error! \n");
			return 1;
		}
		
		/* Do some reading */
		getline(&buf, &len, fp);
		printf("input: %s\n", buf);

		
	}
	
	else {
		printf("Option not available or wrong input type");
		return 1;
	}
	
	fclose(fp);
	return 0;
}
