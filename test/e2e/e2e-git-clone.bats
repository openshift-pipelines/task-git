#!/usr/bin/env bats

source ./test/helper/helper.sh

@test "[e2e] using the task to clone a remote repository" {
	[ -n "${BASE_DIR}" ]

	run kubectl delete taskrun --all
	assert_success

	run tkn task start git \
		--param="URL=https://github.com/tektoncd/community.git" \
		--param="DEPTH=1" \
		--param="VERBOSE=true" \
		--use-param-defaults \
		--workspace name=output,volumeClaimTemplateFile=./test/e2e/resources/workspace-template.yaml \
		--skip-optional-workspace \
		--showlog >&3
	assert_success

	#
	# Asserting Results
	#

	assert_tekton_resource "taskrun" --regexp $'\S+.\nCOMMIT=\S+.\nCOMMITTER_DATE=\S+.\nURL=\S+*'
}