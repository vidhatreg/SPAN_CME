#ifndef _SPAN_CME_H
#define _SPAN_CME_H

#include <linux/ioctl.h>
#define DATA_LENGTH 29

typedef struct {
	short input[DATA_LENGTH];
	short output;
} portifolio_t; //portifolio_t;


#define SPAN_CME_MAGIC 'q'

/* ioctls and their arguments */
#define SPAN_CME_WRITE_DIGIT _IOW(SPAN_CME_MAGIC, 1, portifolio_t *)
#define SPAN_CME_READ_DIGIT  _IOWR(SPAN_CME_MAGIC, 2, portifolio_t *)

#endif
