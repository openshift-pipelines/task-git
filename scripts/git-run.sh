#!/usr/bin/env sh
set -eu

source $(CDPATH= cd -- "$(dirname -- ${0})" && pwd)/common.sh

assert_required_configuration_or_fail

phase "Setting output workspace as safe directory ('${WORKSPACES_SOURCE_PATH}')"
git config --global --add safe.directory "${WORKSPACES_SOURCE_PATH}"

#
# CA (`ssl-ca-directory` Workspace)
#

if [[ "${WORKSPACES_SSL_CA_DIRECTORY_BOUND}" == "true" && -n "${PARAMS_CRT_FILENAME}" ]]; then
	phase "Inspecting 'ssl-ca-directory' workspace looking for '${PARAMS_CRT_FILENAME}' file"
	crt="${WORKSPACES_SSL_CA_DIRECTORY_PATH}/${PARAMS_CRT_FILENAME}"
	[[ ! -f "${crt}" ]] &&
		fail "CRT file (PARAMS_CRT_FILENAME) not found at '${crt}'"

	phase "Exporting custom CA certificate 'GIT_SSL_CAINFO=${crt}'"
	export GIT_SSL_CAINFO=${crt}
fi

#
# Proxy Settings
#

phase "Setting up HTTP_PROXY='${PARAMS_HTTP_PROXY}'"
[[ -n "${PARAMS_HTTP_PROXY}" ]] && export HTTP_PROXY="${PARAMS_HTTP_PROXY}"

phase "Settting up HTTPS_PROXY='${PARAMS_HTTPS_PROXY}'"
[[ -n "${PARAMS_HTTPS_PROXY}" ]] && export HTTPS_PROXY="${PARAMS_HTTPS_PROXY}"

phase "Setting up NO_PROXY='${PARAMS_NO_PROXY}'"
[[ -n "${PARAMS_NO_PROXY}" ]] && export NO_PROXY="${PARAMS_NO_PROXY}"


if [[ ! -z "${PARAMS_URL}" ]];
then
    phase "Cloning '${PARAMS_URL}' into '${checkout_dir}'"
    set -x
    exec git-init \
        -url="${PARAMS_URL}" \
        -revision="${PARAMS_REVISION}" \
        -refspec="${PARAMS_REFSPEC}" \
        -path="${checkout_dir}" \
        -sslVerify="${PARAMS_SSL_VERIFY}" \
        -submodules="${PARAMS_SUBMODULES}" \
        -depth="${PARAMS_DEPTH}" \
        -sparseCheckoutDirectories="${PARAMS_SPARSE_CHECKOUT_DIRECTORIES}"
else
    phase "Running the provided scripts ${PARAMS_GIT_SCRIPT} in ${checkout_dir}"
    eval "${PARAMS_GIT_SCRIPT}"

    RESULT_SHA="$(git rev-parse HEAD | tr -d '\n')"
    EXIT_CODE="$?"
    if [ "$EXIT_CODE" != 0 ]
    then
        exit $EXIT_CODE
    fi
    # Make sure we don't add a trailing newline to the result!
    printf "%s" "$RESULT_SHA" > "${RESULTS_COMMIT_PATH}"
    echo $RESULT_SHA
fi

