.PHONY: bootstrap build push run tty

# Add custom Dockerfile paths to image/
# Example: image/[Symbolic Link]/Dockerfile
# They are ignored with .gitignore

bootstrap:
	sh bootstrap.sh;
build:
	sudo docker build -t=paasta/${n} $$(readlink -f image/${n});
push:
	sh push.sh ${s} ${d};
run:
	sudo docker run ${r} paasta/${n};
tty:
	sudo docker run -i -t paasta/${n} /bin/bash;
