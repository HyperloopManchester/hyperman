.PHONY: clean deps log main motor test web

.DEFAULT_GOAL := main

SCRIPTS=./scripts

log: clean deps
	${SCRIPTS}/test.sh log_node
	${SCRIPTS}/build.sh log_node
	${SCRIPTS}/upload.sh log_node

main: clean deps
	${SCRIPTS}/test.sh main_node
	${SCRIPTS}/build.sh main_node
	${SCRIPTS}/upload.sh main_node

motor: clean deps
	${SCRIPTS}/test.sh motor_node
	${SCRIPTS}/build.sh motor_node
	${SCRIPTS}/upload.sh motor_node

web: clean deps
	${SCRIPTS}/test.sh web_node
	${SCRIPTS}/build.sh web_node
	${SCRIPTS}/upload.sh web_node

test: deps
	${SCRIPTS}/test.sh

deps:
	${SCRIPTS}/deps.sh
	${SCRIPTS}/native-deps.sh
	${SCRIPTS}/test.sh stdlib

clean:
	${SCRIPTS}/clean.sh

