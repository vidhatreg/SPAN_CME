/*
 * Userspace program that communicates with the span_cme peripheral
 * primarily through ioctls
 *
 * Vidhatre Gathey
 * Columbia University
 */

#include <stdio.h>
#include "span_cme.h"
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <inttypes.h>
#define NUM_OF_PORTIFOLIO 3
int span_cme_fd;

/* Read and print the segment values */
void print_output() {
    portifolio_t port;
    if (ioctl(span_cme_fd, SPAN_CME_READ_DIGIT, &port)) {
      perror("ioctl(SPAN_CME_READ_DIGIT) failed");
      return;
    }
    printf("%04d ", port.output);
    FILE *fpout;
    fpout = fopen("output_file.txt","a"); 
    fprintf(fpout,"%04d \n", port.output);
    if (fpout) fclose(fpout);
  //}
  printf("\n");
}

/* Write the contents of the array to the display */
void write_portifolio(short var[])
{
  portifolio_t port;
  int i;
    for (i=0; i< DATA_LENGTH; i++)
    	port.input[i] = var[i];
    port.output = 0;
    if (ioctl(span_cme_fd, SPAN_CME_WRITE_DIGIT, &port)) {
      perror("ioctl(SPAN_CME_WRITE_DIGIT) failed");
      return;
    }
}

int main()
{
  portifolio_t port;
  int i,j,k;
  short var[DATA_LENGTH];
  static const char filename[] = "/dev/span_cme";
  FILE *fpin;
  fpin=fopen("input_file.txt", "r+");
  //FILE *fpout;
  //fpout=fopen("output_file.txt", "a");
  
  printf("SPAN CME Userspace program started\n");

  if ( (span_cme_fd = open(filename, O_RDWR)) == -1) {
    fprintf(stderr, "could not open %s\n", filename);
    return -1;
  }

  for (j = NUM_OF_PORTIFOLIO ; j > 0 ; j--){
  	for(k = 0; k < DATA_LENGTH; k++) 
  		fscanf( fpin, "%hu",&var[k]);
  	//printf( " inputs: %hu, %hu ",var0,var1);
  	write_portifolio(var);
  	print_output();
  	printf(" done : %d \n", j);
  }
  fclose(fpin);
  //fclose(fpout);
  printf("SPAN CME Userspace program terminating\n");
  return 0;
}
