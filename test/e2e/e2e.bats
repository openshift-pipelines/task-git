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
		--workspace="name=output,emptyDir=" \
		--skip-optional-workspace \
		--showlog >&3
	assert_success

	# waiting a few seconds before asserting results
    sleep 30

	# asserting the TaskRun has finished successfuly
	assert_tekton_resource taskrun --partial 'All Steps have completed executing'
	# asserting the results are published as expected, matching the following expression
	assert_tekton_resource taskrun --regexp $'COMMIT=\S+.\nCOMMITTER_DATE=\S+.\nURL=\S+*'
}
