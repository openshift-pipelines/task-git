#!/usr/bin/env sh

export PARAMS_URL="${PARAMS_URL:-}"
export PARAMS_REVISION="${PARAMS_REVISION:-}"
export PARAMS_REFSPEC="${PARAMS_REFSPEC:-}"
export PARAMS_SUBMODULES="${PARAMS_SUBMODULES:-}"
export PARAMS_DEPTH="${PARAMS_DEPTH:-}"
export PARAMS_SSL_VERIFY="${PARAMS_SSL_VERIFY:-}"
export PARAMS_CRT_FILENAME="${PARAMS_CRT_FILENAME:-}"
export PARAMS_SUBDIRECTORY="${PARAMS_SUBDIRECTORY:-}"
export PARAMS_SPARSE_CHECKOUT_DIRECTORIES="${PARAMS_SPARSE_CHECKOUT_DIRECTORIES:-}"
export PARAMS_DELETE_EXISTING="${PARAMS_DELETE_EXISTING:-}"
export PARAMS_HTTP_PROXY="${PARAMS_HTTP_PROXY:-}"
export PARAMS_HTTPS_PROXY="${PARAMS_HTTPS_PROXY:-}"
export PARAMS_NO_PROXY="${PARAMS_NO_PROXY:-}"
export PARAMS_VERBOSE="${PARAMS_VERBOSE:-}"
export PARAMS_USER_HOME="${PARAMS_USER_HOME:-}"

export WORKSPACES_OUTPUT_PATH="${WORKSPACES_OUTPUT_PATH:-}"
export WORKSPACES_SSH_DIRECTORY_BOUND="${WORKSPACES_SSH_DIRECTORY_BOUND:-}"
export WORKSPACES_SSH_DIRECTORY_PATH="${WORKSPACES_SSH_DIRECTORY_PATH:-}"
export WORKSPACES_BASIC_AUTH_BOUND="${WORKSPACES_BASIC_AUTH_BOUND:-}"
export WORKSPACES_BASIC_AUTH_PATH="${WORKSPACES_BASIC_AUTH_PATH:-}"
export WORKSPACES_SSL_CA_DIRECTORY_BOUND="${WORKSPACES_SSL_CA_DIRECTORY_BOUND:-}"
export WORKSPACES_SSL_CA_DIRECTORY_PATH="${WORKSPACES_SSL_CA_DIRECTORY_PATH:-}"

export RESULTS_COMMITTER_DATE_PATH="${RESULTS_COMMITTER_DATE_PATH:-}"
export RESULTS_COMMIT_PATH="${RESULTS_COMMIT_PATH:-}"
export RESULTS_URL_PATH="${RESULTS_URL_PATH:-}"

# full path to the checkout directory, using the output workspace and subdirector parameter
export checkout_dir="${WORKSPACES_OUTPUT_PATH}/${PARAMS_SUBDIRECTORY}"

#
# Functions
#

fail() {
    echo "ERROR: ${@}" 1>&2
    exit 1
}

phase() {
    echo "---> Phase: ${@}..."
}

# Inspect the environment variables to assert the minimum configuration is informed.
assert_required_configuration_or_fail() {
    [[ -z "${PARAMS_URL}" ]] &&
        fail "Parameter URL is not set!"

    [[ -z "${WORKSPACES_OUTPUT_PATH}" ]] &&
        fail "Output Workspace is not set!"

    [[ ! -d "${WORKSPACES_OUTPUT_PATH}" ]] &&
        fail "Output Workspace directory '${WORKSPACES_OUTPUT_PATH}' not found!"

    return 0
}

# Copy the file into the destination, checking if the source exists.
copy_or_fail() {
    local _mode="${1}"
    local _src="${2}"
    local _dst="${3}"

    if [[ ! -f "${_src}" && ! -d "${_src}" ]]; then
        fail "Source file/directory is not found at '${_src}'"
    fi

    if [[ -d "${_src}" ]]; then
        cp -Rv ${_src} ${_dst}
        chmod -v ${_mode} ${_dst}
    else
        install --verbose --mode=${_mode} ${_src} ${_dst}
    fi
}

# Delete any existing contents of the repo directory if it exists. We don't just "rm -rf <dir>"
# because might be "/" or the root of a mounted volume.
clean_dir() {
    local _dir="${1}"

    [[ ! -d "${_dir}" ]] &&
        return 0

    # Delete non-hidden files and directories
    rm -rfv ${_dir:?}/*
    # Delete files and directories starting with . but excluding ..
    rm -rfv ${_dir}/.[!.]*
    # Delete files and directories starting with .. plus any other character
    rm -rfv ${_dir}/..?*
}

#
# Settings
#

# when the ko-app directory is present, making sure it's part of the PATH
[[ -d "/ko-app" ]] && export PATH="${PATH}:/ko-app"

# making the shell verbose when the paramter is set
[[ "${PARAMS_VERBOSE}" == "true" ]] && set -x

return 0