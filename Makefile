.PHONY: clean deps log main motor test web

.DEFAULT_GOAL := main

# this will set the correct linker script and use the correct bsp_*.c source
# for the given platform. see lib/stdlib for the possible values
PLATFORM := $(or $(strip $(PLATFORM)),teensy41)

SCRIPTS := ./scripts

log: clean deps
	${SCRIPTS}/test.sh log_node
	${SCRIPTS}/build.sh log_node ${PLATFORM}
	${SCRIPTS}/upload.sh log_node

main: clean deps
	${SCRIPTS}/test.sh main_node
	${SCRIPTS}/build.sh main_node ${PLATFORM}
	${SCRIPTS}/upload.sh main_node

motor: clean deps
	${SCRIPTS}/test.sh motor_node
	${SCRIPTS}/build.sh motor_node ${PLATFORM}
	${SCRIPTS}/upload.sh motor_node

web: clean deps
	${SCRIPTS}/test.sh web_node
	${SCRIPTS}/build.sh web_node ${PLATFORM}
	${SCRIPTS}/upload.sh web_node

test: deps
	${SCRIPTS}/test.sh

deps:
	${SCRIPTS}/deps.sh ${PLATFORM}
	${SCRIPTS}/native-deps.sh
	${SCRIPTS}/test.sh stdlib

clean:
	${SCRIPTS}/clean.sh

