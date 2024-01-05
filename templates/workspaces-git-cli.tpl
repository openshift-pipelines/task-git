{{- define "workspaces_git_cli" -}}
- name: input
  optional: true
  description: |
    An optional workspace that contains the files that need to be added to git. You can
    access the workspace from your script using `$(workspaces.input.path)`, for instance:

      cp $(workspaces.input.path)/file_that_i_want .
      git add file_that_i_want
      # etc
{{- end -}}