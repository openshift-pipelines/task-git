{{- /*

  Contains the results produced by buildah, should be part of a Tasks ".spec.results[]".

*/ -}}
{{- define "common_workspaces" -}}
- name: ssh-directory
  optional: true
  description: |
    A `.ssh` directory with private key, `known_hosts`, `config`, etc.
    Copied to the Git user's home before cloning the repository, in order to
    server as authentication mechanismBinding a Secret to this Workspace is
    strongly recommended over other volume types.
- name: basic-auth
  optional: true
  description: |
    A Workspace containing a `.gitconfig` and `.git-credentials` files.
    These will be copied to the user's home before Git commands run. All
    other files in this Workspace are ignored. It is strongly recommended to
    use `ssh-directory` over `basic-auth` whenever possible, and to bind a
    Secret to this Workspace over other volume types.
- name: ssl-ca-directory
  optional: true
  description: |
    A Workspace containing CA certificates, this will be used by Git to
    verify the peer with when interacting with remote repositories using
    HTTPS.
{{- end -}}