{{- define "common_steps" -}}
  {{- $workspace := index . 1 -}}
  {{- with index . 0 -}}
- name: prepare
  image: {{ .Values.images.gitInit }}
  {{- if eq $workspace "source" }}
  workingDir: $(workspaces.source.path)
  {{- end }}
  {{- if eq $workspace "output" }}
  workingDir: $(workspaces.output.path)
  {{- end }}
  command:
    - /scripts/prepare.sh
  volumeMounts:
    - name: scripts-dir
      mountPath: /scripts
    - name: user-home
      mountPath: "$(params.USER_HOME)"

- name: git-run
  image: {{ .Values.images.gitInit }}
  {{- if eq $workspace "source" }}
  workingDir: $(workspaces.source.path)
  {{- end }}
  {{- if eq $workspace "output" }}
  workingDir: $(workspaces.output.path)
  {{- end }}
  command:
    - /scripts/git-run.sh
  volumeMounts:
    - name: scripts-dir
      mountPath: /scripts
    - name: user-home
      mountPath: "$(params.USER_HOME)"
  {{- end -}}
{{- end -}}