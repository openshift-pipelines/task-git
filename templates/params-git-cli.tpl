{{- define "params_git_cli" -}}
- name: GIT_USER_NAME
  type: string
  description: |
    Git user name for performing git operation.
  default: ""
- name: GIT_USER_EMAIL
  type: string
  description: |
    Git user email for performing git operation.
  default: ""
- name: GIT_SCRIPT
  description: The git script to run.
  type: string
  default: |
    git help
{{- end -}}