{{- define "common_steps" -}}
  {{- $workspace := index . 1 -}}
  {{- with index . 0 -}}
- name: prepare-and-run
  image: {{ .Values.images.gitInit }}
  {{- if eq $workspace "source" }}
  workingDir: $(workspaces.source.path)
  {{- end }}
  {{- if eq $workspace "output" }}
  workingDir: $(workspaces.output.path)
  {{- end }}
  script: |
{{- include "load_scripts" ( list . ( list "" ) ( list "/scripts/prepare.sh" "/scripts/git-run.sh" ) ) | nindent 4 }}
  volumeMounts:
    - name: scripts-dir
      mountPath: /scripts
    - name: user-home
      mountPath: "$(params.USER_HOME)"
  {{- end -}}
{{- end -}}