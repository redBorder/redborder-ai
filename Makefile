MKL_RED?=		\033[031m
MKL_GREEN?=		\033[032m
MKL_YELLOW?=	\033[033m
MKL_BLUE?=		\033[034m
MKL_CLR_RESET?=	\033[0m


all: rpm

rpm:
	$(MAKE) -C packaging/rpm

rpmtest:
	$(MAKE) LATEST=`git stash create` -C packaging/rpm

clean:
	rm resources/model/*
	rmdir resources/model