#include <stdio.h>
int main()
{
 FILE *fp;
 fp = fopen("/opt/container/process2/data/process1_direct.txt","w");
 fprintf(fp,"%s","This file was created by process 1");
 fclose(fp);
 return 0;
}
