.PHONY: build run tty rm rmi

# Add custom Dockerfile paths to image/
# Example: image/[Symbolic Link]/Dockerfile
# They are ignored with .gitignore

b = -rm=true
y = -i -t
s = hapi
t = ${s}/${n}
p = image/${n}

build:
	sudo docker build ${b} -t=${t} ${p}
run:
	sudo docker run ${r} ${t}
tty:
	sudo docker run ${y} ${t} /bin/bash
rm:
	sudo docker ps -a | grep "Exit" | awk '{print $$1}' | sudo xargs docker rm
rmi:
	sudo docker images | grep "<none>" | awk '{print $$3}' | sudo xargs docker rmi
