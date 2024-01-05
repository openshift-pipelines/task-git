{{- define "common_steps" -}}
- name: prepare
  image: {{ .Values.images.gitInit }}
  workingDir: $(workspaces.source.path)
  command:
    - /scripts/prepare.sh
  volumeMounts:
    - name: scripts-dir
      mountPath: /scripts
    - name: user-home
      mountPath: "$(params.USER_HOME)"

- name: git-run
  image: {{ .Values.images.gitInit }}
  workingDir: $(workspaces.source.path)
  command:
    - /scripts/git-run.sh
  volumeMounts:
    - name: scripts-dir
      mountPath: /scripts
    - name: user-home
      mountPath: "$(params.USER_HOME)"
{{- end -}}