{{- /*

  This template is meant to translate the Tekton placeholder utilized by the shell scripts, thus the
  scripts can rely on a pre-defined and repetable way of consuming Tekton attributes.

    Example:
      The placeholder `workspaces.a.b` becomes `WORKSPACES_A_B`

*/ -}}
{{- define "common_environment_variables" -}}
    {{- range list
          "params.GIT_INIT_IMAGE"
          "params.SSL_VERIFY"
          "params.CRT_FILENAME"
          "params.SUBDIRECTORY"
          "params.DELETE_EXISTING"
          "params.HTTP_PROXY"
          "params.HTTPS_PROXY"
          "params.NO_PROXY"
          "params.VERBOSE"
          "params.USER_HOME"
          "workspaces.ssh-directory.bound"
          "workspaces.ssh-directory.path"
          "workspaces.basic-auth.bound"
          "workspaces.basic-auth.path"
          "workspaces.ssl-ca-directory.bound"
          "workspaces.ssl-ca-directory.path"
          "results.commit.path"
    }}
- name: {{ . | upper | replace "." "_" | replace "-" "_" }}
  value: "$({{ . }})"
    {{- end -}}
{{- end -}}