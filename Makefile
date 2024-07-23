MKL_RED?=		\033[031m
MKL_GREEN?=		\033[032m
MKL_YELLOW?=	\033[033m
MKL_BLUE?=		\033[034m
MKL_CLR_RESET?=	\033[0m


all: rpm

rpm:
	mkdir -p resources/model
	@printf "$(MKL_YELLOW)Downloading the model $(BIN)$(MKL_CLR_RESET)\n"
	# curl -L https://huggingface.co/Mozilla/llava-v1.5-7b-llamafile/resolve/main/llava-v1.5-7b-q4.llamafile?download=true -o resources/model/llava-v1.5-7b-q4.llamafile
	@if [ ! -f resources/model/llava-v1.5-7b-q4.llamafile ]; then printf "$(MKL_RED)Model dont downloaded$(MKL_CLR_RESET)\n"; exit 1; fi
	@printf "$(MKL_GREEN)Model downloaded successfully$(MKL_CLR_RESET)\n"
	$(MAKE) -C packaging/rpm

rpmtest:
	$(MAKE) LATEST=`git stash create` -C packaging/rpm

clean:
	rm resources/model/*
	rmdir resources/model