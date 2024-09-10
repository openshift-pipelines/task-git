{{- define "stepaction_params_git_clone" -}}
- name: OUTPUT_PATH
  description: |
    A directory that contains the fetched git repository. Cloned repo data is
    placed in the root of the directory or in the relative path defined by the
    `SUBDIRECTORY` parameter
- name: SSH_DIRECTORY_PATH
  description: |
    A `.ssh` directory with private key, `known_hosts`, `config`, etc.
    Copied to the Git user's home before cloning the repository, in order to
    server as authentication mechanismBinding a Secret to this Workspace is
    strongly recommended over other volume types.
  default: "no-path"
- name: BASIC_AUTH_PATH
  default: "no-path"
  description: |
    A directory containing `.gitconfig` and `.git-credentials` files.
    These files are copied to the user home directory before Git commands run.
    All other files in this Workspace are ignored. It is strongly recommended to
    use `ssh-directory` over `basic-auth` whenever possible, and to bind a
    Secret to the Workspace providing this directory.
- name: SSL_CA_DIRECTORY_PATH
  default: "no-path"
  description: |
    A directory containing CA certificates. Git uses these certificates to
    verify the peer with when interacting with remote repositories using
    HTTPS.
{{- end -}}
