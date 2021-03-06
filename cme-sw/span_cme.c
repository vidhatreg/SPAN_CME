/*
 * Device driver for span cme hardware component 
 *
 *
 * Vidhatre Gathey
 * Columbia University
 *
 * References:
 * Linux source: Documentation/driver-model/platform.txt
 *               drivers/misc/arm-charlcd.c
 * http://www.linuxforu.com/tag/linux-device-drivers/
 * http://free-electrons.com/docs/
 *
 * "make" to build
 * insmod span_cme.ko
 *
 * Check code style with
 * checkpatch.pl --file --no-tree span_cme.c
 */

#include <linux/module.h>
#include <linux/init.h>
#include <linux/errno.h>
#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/platform_device.h>
#include <linux/miscdevice.h>
#include <linux/slab.h>
#include <linux/io.h>
#include <linux/of.h>
#include <linux/of_address.h>
#include <linux/fs.h>
#include <linux/uaccess.h>
#include "span_cme.h"

#define DRIVER_NAME "span_cme"

/*
 * Information about our device
 */
struct span_cme_dev {
	struct resource res; /* Resource: our registers */
	void __iomem *virtbase; /* Where registers can be accessed in memory */
	//short input[DATA_LENGTH];
	//short output;
} dev;

/*
 * Write segments of a single digit
 * Assumes digit is in range and the device information has been set up
 */
static void write_digit(short input[])//, short input1)
{
	/*iowrite16(input0, dev.virtbase);
	iowrite16(input1, dev.virtbase +2);
	dev.input[0] = input0;
	dev.input[1] = input1;
	*/
	int it; 
	for ( it = 0; it < DATA_LENGTH; it++) {
		iowrite16(input[it], dev.virtbase + (2*it));
//		dev.input[it] = input[it];
	}
	
}

static short read_digit()
{
	return ioread16(dev.virtbase);
}
/*
 * Handle ioctl() calls from userspace:
 * Read or write the segments on single digits.
 * Note extensive error checking of arguments
 */
static long span_cme_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
{
	portifolio_t vla;

	switch (cmd) {
	case SPAN_CME_WRITE_DIGIT:
		if (copy_from_user(&vla, (portifolio_t *) arg,
				   sizeof(portifolio_t)))
			return -EACCES;
		//if (vla.digit > 8)
		//	return -EINVAL;
		write_digit(vla.input);
		break;

	case SPAN_CME_READ_DIGIT:
		if (copy_from_user(&vla, (portifolio_t *) arg,
				   sizeof(portifolio_t)))
			return -EACCES;
		//if (vla.digit > 8)
		//	return -EINVAL;
		vla.output = read_digit();
//		dev.output = vla.output;
		if (copy_to_user((portifolio_t *) arg, &vla,
				 sizeof(portifolio_t)))
			return -EACCES;
		break;

	default:
		return -EINVAL;
	}

	return 0;
}

/* The operations our device knows how to do */
static const struct file_operations span_cme_fops = {
	.owner		= THIS_MODULE,
	.unlocked_ioctl = span_cme_ioctl,
};

/* Information about our device for the "misc" framework -- like a char dev */
static struct miscdevice span_cme_misc_device = {
	.minor		= MISC_DYNAMIC_MINOR,
	.name		= DRIVER_NAME,
	.fops		= &span_cme_fops,
};

/*
 * Initialization code: get resources (registers) and display
 * a welcome message
 */
static int __init span_cme_probe(struct platform_device *pdev)
{
	//static unsigned char welcome_message[SPAN_CME_DIGITS] = {
	//	0x3E, 0x7D, 0x77, 0x08, 0x38, 0x79, 0x5E, 0x00};
	//int i;
	int ret;

	/* Register ourselves as a misc device: creates /dev/span_cme */
	ret = misc_register(&span_cme_misc_device);

	/* Get the address of our registers from the device tree */
	ret = of_address_to_resource(pdev->dev.of_node, 0, &dev.res);
	if (ret) {
		ret = -ENOENT;
		goto out_deregister;
	}

	/* Make sure we can use these registers */
	if (request_mem_region(dev.res.start, resource_size(&dev.res),
			       DRIVER_NAME) == NULL) {
		ret = -EBUSY;
		goto out_deregister;
	}

	/* Arrange access to our registers */
	dev.virtbase = of_iomap(pdev->dev.of_node, 0);
	if (dev.virtbase == NULL) {
		ret = -ENOMEM;
		goto out_release_mem_region;
	}

	/* Display a welcome message */
	//for (i = 0; i < SPAN_CME_DIGITS; i++)
	//	write_digit(i, welcome_message[i]);

	return 0;

out_release_mem_region:
	release_mem_region(dev.res.start, resource_size(&dev.res));
out_deregister:
	misc_deregister(&span_cme_misc_device);
	return ret;
}

/* Clean-up code: release resources */
static int span_cme_remove(struct platform_device *pdev)
{
	iounmap(dev.virtbase);
	release_mem_region(dev.res.start, resource_size(&dev.res));
	misc_deregister(&span_cme_misc_device);
	return 0;
}

/* Which "compatible" string(s) to search for in the Device Tree */
#ifdef CONFIG_OF
static const struct of_device_id span_cme_of_match[] = {
	{ .compatible = "altr,span_cme" },
	{},
};
MODULE_DEVICE_TABLE(of, span_cme_of_match);
#endif

/* Information for registering ourselves as a "platform" driver */
static struct platform_driver span_cme_driver = {
	.driver	= {
		.name	= DRIVER_NAME,
		.owner	= THIS_MODULE,
		.of_match_table = of_match_ptr(span_cme_of_match),
	},
	.remove	= __exit_p(span_cme_remove),
};

/* Called when the module is loaded: set things up */
static int __init span_cme_init(void)
{
	pr_info(DRIVER_NAME ": init\n");
	return platform_driver_probe(&span_cme_driver, span_cme_probe);
}

/* Called when the module is unloaded: release resources */
static void __exit span_cme_exit(void)
{
	platform_driver_unregister(&span_cme_driver);
	pr_info(DRIVER_NAME ": exit\n");
}

module_init(span_cme_init);
module_exit(span_cme_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Vidhatre Gathey, Columbia University");
MODULE_DESCRIPTION("kernel interface with span_cme module");
