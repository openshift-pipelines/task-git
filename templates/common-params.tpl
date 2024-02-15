{{- /*

  Contains the results produced by buildah, should be part of a Tasks ".spec.results[]".

*/ -}}
{{- define "common_params" -}}
- name: CRT_FILENAME
  type: string
  default: ca-bundle.crt
  description: |
    Certificate Authority (CA) bundle filename on the `ssl-ca-directory`
    Workspace.
- name: HTTP_PROXY
  type: string
  default: ""
  description: |
    HTTP proxy server (non-TLS requests).
- name: HTTPS_PROXY
  type: string
  default: ""
  description: |
    HTTPS proxy server (TLS requests).
- name: NO_PROXY
  type: string
  default: ""
  description: |
    Opt out of proxying HTTP/HTTPS requests.
- name: SUBDIRECTORY
  type: string
  default: ""
  description: |
    Relative path to the default Workspace where the git repository will be present.
- name: USER_HOME
  type: string
  default: "/home/git"
  description: |
    Absolute path to the Git user home directory.
- name: DELETE_EXISTING
  type: string
  default: "true"
  description: |
    Clean out the contents of the default Workspace before specific git operations occur, if data exists.
- name: VERBOSE
  type: string
  default: "false"
  description: |
    Log the commands executed.
- name: SSL_VERIFY
  type: string
  default: "true"
  description: |
    Sets the global `http.sslVerify` value, `false` is not advised unless
    you trust the remote repository.
{{- end -}}