{{- define "helm-chart-library.configmap" -}}
{{- if .Values.configmap -}}
{{- if .Values.configmap.enabled -}}
{{- if default true .Values.configmap.uselibrary -}}
{{- $requiredMsg := include "helm-chart-library.default-check-required-msg" . -}}
{{- $global := (ternary .Global .Values (hasKey . "Global"))}}
{{- $name := include "helm-chart-library.name" . }}
{{- $files := .Files }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $name }}-config
  {{- with .Values.configmap.annotations }}
  annotations:
    {{- toYaml . | nindent 8 }}
  {{- end }}
  labels:
    {{- include "helm-chart-library.labels" . | nindent 4 }}
{{- if .Values.configmap.folderPath }}
data:
{{- range $path, $bytes := .Files.Glob ( printf "%s/**" .Values.configmap.folderPath ) }}
  {{ base $path | indent 2}}: |-
    {{- $.Files.Get $path | trim | nindent 6 -}}
{{ end }}
{{- else }}
data:
{{- $fileFound := false }}
{{- range $key, $value := .Values.configmap.data }}
{{- if (or (hasKey $value "json") (hasKey $value "file")) }}
{{- $fileFound = true }}
{{- if hasKey $value "json" }}
{{ print $key | indent 2 }}.json:
    |-
{{ $value.json | indent 6 }}
{{- end }}
{{- if hasKey $value "file" }}
{{ print $key | indent 2 }}:
{{ toJson ($files.Get $value.file) | indent 4}}
{{- end }}
{{- end }}
{{- end }}
{{- if not $fileFound }}
  {}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}