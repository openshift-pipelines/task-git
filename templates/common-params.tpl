{{- /*

  Contains the results produced by buildah, should be part of a Tasks ".spec.results[]".

*/ -}}
{{- define "common_params" -}}
- name: CRT_FILENAME
  type: string
  default: ca-bundle.crt
  description: |
    Certificate Authority (CA) bundle filename in the SSL CA directory.
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
    Path to the directory for storing the cloned Git repository, relative to the
    output directory.
- name: USER_HOME
  type: string
  default: "/home/git"
  description: |
    Absolute path to the Git user home directory.
- name: DELETE_EXISTING
  type: string
  default: "true"
  description: |
    Clean out the contents of the default Workspace before specific Git operations occur, if data exists.
- name: VERBOSE
  type: string
  default: "false"
  description: |
    Log the executed commands.
- name: SSL_VERIFY
  type: string
  default: "true"
  description: |
    Sets the global `http.sslVerify` value, `false` is not advised unless
    you trust the remote repository.
{{- end -}}
