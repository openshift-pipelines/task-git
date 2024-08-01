#!/usr/bin/env bats

source ./test/helper/helper.sh

@test "[e2e] using the stepaction to clone a remote repository" {
	[ -n "${BASE_DIR}" ]

	run kubectl delete taskrun --all
	assert_success

	run tkn task start --filename=test/e2e/resources/task-git-clone.yaml \
		--param="repo-url=https://github.com/tektoncd/pipeline.git" \
		--param="tag-name=v0.62.0" \
		--param="expected-sha=95fbf318460a2f73ac505bbdb13786a788d1c092" \
		--use-param-defaults \
		--workspace name=output,volumeClaimTemplateFile=./test/e2e/resources/workspace-template.yaml \
		--skip-optional-workspace \
		--showlog >&3
	assert_success

    # waiting a few seconds before asserting results
	sleep 30

	#
	# Asserting Results
	#

	assert_tekton_resource "taskrun" --regexp $'\S+\nCOMMIT=\S+\nCOMMITTER_DATE=\S+\nURL=\S+'
}
