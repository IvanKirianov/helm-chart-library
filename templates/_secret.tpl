{{- define "helm-chart-library.secret" -}}
{{- $requiredMsg := include "helm-chart-library.default-check-required-msg" . -}}
{{- $global := (ternary .Global .Values (hasKey . "Global"))}}
{{- $name := include "helm-chart-library.name" . }}
{{- $files := .Files }}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ $name }}-secret
  {{- with .Values.annotations }}
  annotations:
    {{- toYaml . | nindent 8 }}
  {{- end }}
  labels:
    {{- include "helm-chart-library.labels" . | nindent 4 }}
data:
{{- $filedict := .Files.Get .Values.secretFilePath | fromYaml  }}
{{- range $key, $val := $filedict }}
  {{ $key }}: {{ $val | decryptAES $global.aesKey | b64enc | quote }}
{{- end }}
{{- end }}