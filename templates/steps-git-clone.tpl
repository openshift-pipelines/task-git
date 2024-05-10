{{- define "steps_git_clone" -}}
- name: report
  image: "$(params.GIT_INIT_IMAGE)"
  command:
    - /scripts/report.sh
  volumeMounts:
    - name: scripts-dir
      mountPath: /scripts
{{- end -}}