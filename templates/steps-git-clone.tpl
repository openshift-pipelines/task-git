{{- define "steps_git_clone" -}}
- name: report
  image: {{ .Values.images.gitInit }}
  command:
    - /scripts/report.sh
  volumeMounts:
    - name: scripts-dir
      mountPath: /scripts
{{- end -}}