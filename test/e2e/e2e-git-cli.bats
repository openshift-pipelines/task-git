#!/usr/bin/env bats

source ./test/helper/helper.sh

# E2E tests parameters for the test pipeline

# Testing the git-cli task,
@test "[e2e] git-cli task" {

    run tkn pipeline start task-git-cli \
        --workspace name=source,volumeClaimTemplateFile=./test/e2e/resources/workspace-template.yaml \
        --filename=test/e2e/resources/pipeline-git-cli.yaml \
        --showlog \
        --use-param-defaults
    assert_success

    # waiting a few seconds before asserting results
	sleep 30

    # assering the taskrun status, making sure all steps have been successful
    assert_tekton_resource "taskrun" --regexp $'\S+\nCOMMIT=6c073b08f7987018cbb2cb9a5747c84913b3608e'
    assert_tekton_resource "pipelinerun" --partial '(Failed: 0, Cancelled 0), Skipped: 0'
}
