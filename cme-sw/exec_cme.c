/*
 * -Userspace program that communicates with the span_cme peripheral
 *  primarily through ioctls
 * -program reads the portifolio data from the "input_file.txt"
 * -program outputs all the read data from the peripheral to "output_file.txt"
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
#define NUM_OF_PORTIFOLIO 3 // number of portifolios the input contains
int span_cme_fd;

/* function to read the output from the board using an ioctl function, 
 * open an output file, and 
 * append the output data to the file 
 */
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
  printf("\n");
}

/* Write the contents of the input portifolio data to the board, 
 * used the ioctl function to wrtie to the board
 */
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
  portifolio_t port;		// portifolio template as described in the header span_cme.h
  int i,j,k;			// iterators
  short var[DATA_LENGTH];       // used as a buffer for storing the data from the input file as it is read
  char label[DATA_LENGTH][14];  // store the first line of labels from the input file
  static const char filename[] = "/dev/span_cme"; 
  clock_t begin_time, end_time;
  FILE *fpin;
  fpin=fopen("input_file.txt", "r+");

  printf("SPAN CME Userspace program started\n");
  begin_time = clock();
  if ( (span_cme_fd = open(filename, O_RDWR)) == -1) {
    fprintf(stderr, "could not open %s\n", filename);
    return -1;
  }
  
  for(k = 0; k < DATA_LENGTH; k++)		// read portifolio labels
  	fscanf( fpin, "%s",&label[k]);

  for (j = NUM_OF_PORTIFOLIO ; j > 0 ; j--){   // read the first set of data i.e. from the portifolio
  	for(k = 0; k < DATA_LENGTH; k++) 
  		fscanf( fpin, "%hu",&var[k]);
  	//printf( " inputs: %hu, %hu ",var0,var1);
  	write_portifolio(var);
  	print_output();
	// debug: outputs
  	printf(" done : %d \n", j);
  }
  fclose(fpin);
  //fclose(fpout);
  end_time = clock();

  printf("total execution time: %f \n", (double) (end_time - begin_time)/CLOCKS_PER_SEC );
  printf("SPAN CME Userspace program terminating\n");
  return 0;
}
