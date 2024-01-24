{{- define "workspaces_git_clone" -}}
- name: output
  description: |
    A workspace that contains the fetched git repository, data will be placed on the root of the
    Workspace, or on the relative path defined by the SUBDIRECTORY
    parameter.
{{- end -}}