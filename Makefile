
all: rpm

rpm:
	curl -L https://huggingface.co/Mozilla/llava-v1.5-7b-llamafile/resolve/main/llava-v1.5-7b-q4.llamafile?download=true -o resources/model/llava-v1.5-7b-q4.llamafile
	$(MAKE) -C packaging/rpm

rpmtest:
	$(MAKE) LATEST=`git stash create` -C packaging/rpm