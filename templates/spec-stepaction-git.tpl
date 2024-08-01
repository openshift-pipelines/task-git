{{- define "spec_stepaction_git" -}}
  {{- $params := index . 1 -}}
  {{- $results := index . 2 -}}
  {{- $env_vars := index . 3 -}}
  {{- $global := index . 0 -}}
  {{- with index . 0 -}}
params:
{{- include "stepaction_params_git_clone" . | nindent 2}}
{{- include "common_params" . | nindent 2}}
{{- if ne $params "" }}
  {{- include $params . | nindent 2}}
{{- end}}

results:
  - name: COMMIT
    description: |
      The precise commit SHA digest cloned.
{{- if ne $results "" }}
  {{- include $results . | nindent 2}}
{{- end}}

env:
{{- include "environment" ( list $env_vars ) | nindent 2 }}
{{- include "stepaction_environment_variables" . | nindent 2 }}

{{- if .Values.securityContext }}
securityContext:
{{- .Values.securityContext | toYaml | nindent 2 }}
{{- end}}

image: {{ $global.Values.images.gitInit }}

script: |
  #!/usr/bin/env sh
  set -eu

  if [ "${PARAMS_VERBOSE}" = "true" ] ; then
    set -x
  fi

  if [ "${PARAMS_BASIC_AUTH_PATH}" != "no-path" ] ; then
    cp "${PARAMS_BASIC_AUTH_PATH}/.git-credentials" "${PARAMS_USER_HOME}/.git-credentials"
    cp "${PARAMS_BASIC_AUTH_PATH}/.gitconfig" "${PARAMS_USER_HOME}/.gitconfig"
    chmod 400 "${PARAMS_USER_HOME}/.git-credentials"
    chmod 400 "${PARAMS_USER_HOME}/.gitconfig"
  fi

  if [ "${PARAMS_SSH_DIRECTORY_PATH}" != "no-path" ] ; then
    cp -R "${PARAMS_SSH_DIRECTORY_PATH}" "${PARAMS_USER_HOME}"/.ssh
    chmod 700 "${PARAMS_USER_HOME}"/.ssh
    chmod -R 400 "${PARAMS_USER_HOME}"/.ssh/*
  fi

  if [ "${PARAMS_SSL_CA_DIRECTORY_PATH}" != "no-path" ] ; then
     export GIT_SSL_CAPATH="${PARAMS_SSL_CA_DIRECTORY_PATH}"
     if [ "${PARAMS_CRT_FILENAME}" != "" ] ; then
        export GIT_SSL_CAINFO="${PARAMS_SSL_CA_DIRECTORY_PATH}/${PARAMS_CRT_FILENAME}"
     fi
  fi
  CHECKOUT_DIR="${PARAMS_OUTPUT_PATH}/${PARAMS_SUBDIRECTORY}"

  cleandir() {
    # Delete any existing contents of the repo directory if it exists.
    #
    # We don't just "rm -rf ${CHECKOUT_DIR}" because ${CHECKOUT_DIR} might be "/"
    # or the root of a mounted volume.
    if [ -d "${CHECKOUT_DIR}" ] ; then
      # Delete non-hidden files and directories
      rm -rf "${CHECKOUT_DIR:?}"/*
      # Delete files and directories starting with . but excluding ..
      rm -rf "${CHECKOUT_DIR}"/.[!.]*
      # Delete files and directories starting with .. plus any other character
      rm -rf "${CHECKOUT_DIR}"/..?*
    fi
  }

  if [ "${PARAMS_DELETE_EXISTING}" = "true" ] ; then
    cleandir || true
  fi

  test -z "${PARAMS_HTTP_PROXY}" || export HTTP_PROXY="${PARAMS_HTTP_PROXY}"
  test -z "${PARAMS_HTTPS_PROXY}" || export HTTPS_PROXY="${PARAMS_HTTPS_PROXY}"
  test -z "${PARAMS_NO_PROXY}" || export NO_PROXY="${PARAMS_NO_PROXY}"

  git config --global --add safe.directory "${PARAMS_OUTPUT_PATH}"
  /ko-app/git-init \
    -url="${PARAMS_URL}" \
    -revision="${PARAMS_REVISION}" \
    -refspec="${PARAMS_REFSPEC}" \
    -path="${CHECKOUT_DIR}" \
    -sslVerify="${PARAMS_SSL_VERIFY}" \
    -submodules="${PARAMS_SUBMODULES}" \
    -depth="${PARAMS_DEPTH}" \
    -sparseCheckoutDirectories="${PARAMS_SPARSE_CHECKOUT_DIRECTORIES}"
  cd "${CHECKOUT_DIR}"
  RESULT_SHA="$(git rev-parse HEAD)"
  EXIT_CODE="$?"
  if [ "${EXIT_CODE}" != 0 ] ; then
    exit "${EXIT_CODE}"
  fi
  RESULT_COMMITTER_DATE="$(git log -1 --pretty=%ct)"
  printf "%s" "${RESULT_COMMITTER_DATE}" > "$(step.results.COMMITTER_DATE.path)"
  printf "%s" "${RESULT_SHA}" > "$(step.results.COMMIT.path)"
  printf "%s" "${PARAMS_URL}" > "$(step.results.URL.path)"
  {{- end -}}
{{- end -}}