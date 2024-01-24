#!/usr/bin/env sh
#
# Sets up the basic and SSH authentication based on informed workspaces, as well as cleaning up the
# previous git-clone stale data.
#

set -eu

source $(CDPATH= cd -- "$(dirname -- ${0})" && pwd)/common.sh

assert_required_configuration_or_fail

phase "Preparing the filesystem before cloning the repository"

if [[ "${PARAMS_DELETE_EXISTING}" == "true" ]]; then
	phase "Deleting all contents of checkout-dir '${checkout_dir}'"
	clean_dir ${checkout_dir} || true
fi

if [[ "${WORKSPACES_BASIC_AUTH_BOUND}" == "true" ]]; then
	phase "Configuring Git authentication with 'basic-auth' Workspace files"

	for f in .git-credentials .gitconfig; do
		src="${WORKSPACES_BASIC_AUTH_PATH}/${f}"
		phase "Copying '${src}' to '${PARAMS_USER_HOME}'"
		copy_or_fail 400 ${src} "${PARAMS_USER_HOME}/"
	done
fi

if [[ "${WORKSPACES_SSH_DIRECTORY_BOUND}" == "true" ]]; then
	phase "Copying '.ssh' from ssh-directory workspace ('${WORKSPACES_SSH_DIRECTORY_PATH}')"

	dot_ssh="${PARAMS_USER_HOME}/.ssh"
	copy_or_fail 700 ${WORKSPACES_SSH_DIRECTORY_PATH} ${dot_ssh}
	chmod -Rv 400 ${dot_ssh}/*
fi

# Setting up the config for the git.

if [ -n "${PARAMS_GIT_USER_EMAIL}" ] ; then
	echo "${[ -n "${PARAMS_GIT_USER_EMAIL}"]}"
    phase "Setting global email for git ${PARAMS_GIT_USER_EMAIL}"
    git config --global user.email "${PARAMS_GIT_USER_EMAIL}"
fi

if [ -n "${PARAMS_GIT_USER_NAME}" ] ; then
    phase "Setting global username for git ${PARAMS_GIT_USER_NAME}"
    git config --global user.name "${PARAMS_GIT_USER_NAME}"
fi

exit 0