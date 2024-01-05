{{- define "spec_git" -}}
  {{- $workspaces := index . 1 -}}
  {{- $params := index . 2 -}}
  {{- $results := index . 3 -}}
  {{- $env_vars := index . 4 -}}
  {{- $steps := index . 5 -}}
  {{- with index . 0 -}}
workspaces:
{{- include "common_workspaces" . | nindent 2}}
{{- if ne $workspaces "" }}
  {{- include $workspaces . | nindent 2}}
{{- end}}

params:
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

volumes:
  - name: user-home
    emptyDir: {}
  - name: scripts-dir
    emptyDir: {}

stepTemplate:
  env:
{{- include "environment" ( list $env_vars ) | nindent 4 }}
{{- include "common_environment_variables" . | nindent 4 }}

{{- if .Values.stepTemplate.computeResources }}
  computeResources:
  {{- .Values.stepTemplate.computeResources | toYaml | nindent 4 }}
{{- end }}
{{- if .Values.stepTemplate.securityContext }}
  securityContext:
  {{- .Values.stepTemplate.securityContext | toYaml | nindent 4 }}
{{- end }}

steps:
{{- include "load_scripts" ( list . "" ) | nindent 2 }}
{{- include "common_steps" . | nindent 2 }}
{{- if ne $steps "" }}
  {{- include $steps . | nindent 2}}
{{- end}}

  {{- end -}}
{{- end -}}