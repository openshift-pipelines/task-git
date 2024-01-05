{{- define "params_git_clone" -}}
- name: URL
  type: string
  description: |
    Git repository URL.
- name: REVISION
  type: string
  default: main
  description: |
    Revision to checkout, an branch, tag, sha, ref, etc...
- name: REFSPEC
  default: ""
  description: |
    Repository `refspec` to fetch before checking out the revision.
- name: SUBMODULES
  type: string
  default: "true"
  description: |
    Initialize and fetch Git submodules.
- name: DEPTH
  type: string
  default: "1"
  description: |
    Number of commits to fetch, a "shallow clone" is a single commit.
- name: SPARSE_CHECKOUT_DIRECTORIES
  type: string
  default: ""
  description: |
    List of directory patterns split by comma to perform "sparse checkout".
{{- end -}}