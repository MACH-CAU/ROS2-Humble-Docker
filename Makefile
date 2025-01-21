
MAKE=make --no-print-directory

all: build
	@$(MAKE) run

build:
	@echo [COMMAND] | tr '\n' ' '
	docker build --tag ros2:humble .

# -d 가 없으면 따로 돌지 않기 때문에 bash 끄면 꺼짐
run:
	@echo [COMMAND] | tr '\n' ' '
	docker run -p 8042:22 --name ros -it ros2:humble

run_d:
	@echo [COMMAND] | tr '\n' ' '
	docker run -p 8042:22 -d --name ros -it ros2:humble
# docker run -d --name ros -it ros2:humble

exec:
	@echo [COMMAND] | tr '\n' ' '
	docker exec -it ros bash

start: 
	@echo [COMMAND] | tr '\n' ' '
	docker start ros:humble

stop:
	@echo [COMMAND] | tr '\n' ' '
	docker stop ros

rm:
	@echo [COMMAND] | tr '\n' ' '
	docker rm ros

clean:
	@$(MAKE) stop rm

re: clean
	@$(MAKE) all


.PHONY: all build run exec start stop rm clean

