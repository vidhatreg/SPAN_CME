ifneq (${KERNELRELEASE},)

# KERNELRELEASE defined: we are being compiled as part of the Kernel
        obj-m := span_cme.o

else

# We are being compiled as a module: use the Kernel build system

	KERNEL_SOURCE := /usr/src/linux
        PWD := $(shell pwd)

default: module exec_cme

module:
	${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} modules

clean:
	${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} clean
	${RM} exec_cme

socfpga.dtb : socfpga.dtb
	dtc -O dtb -o socfpga.dtb socfpga.dts

endif 
