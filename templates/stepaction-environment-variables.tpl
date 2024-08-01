{{- /*

  This template is meant to translate the Tekton placeholder utilized by the shell scripts, thus the
  scripts can rely on a pre-defined and repeatable way of consuming Tekton attributes.

    Example:
      The placeholder `workspaces.a.b` becomes `WORKSPACES_A_B`

*/ -}}
{{- define "stepaction_environment_variables" -}}
    {{- range list
          "params.SSL_VERIFY"
          "params.CRT_FILENAME"
          "params.SUBDIRECTORY"
          "params.DELETE_EXISTING"
          "params.HTTP_PROXY"
          "params.HTTPS_PROXY"
          "params.NO_PROXY"
          "params.VERBOSE"
          "params.USER_HOME"
    }}
- name: {{ . | upper | replace "." "_" | replace "-" "_" }}
  value: "$({{ . }})"
    {{- end -}}
{{- end -}}