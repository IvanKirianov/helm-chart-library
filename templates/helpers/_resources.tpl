{{/*
Template for container resources
*/}}
{{- define "helm-chart-library.resources" -}}
{{- $requiredMsg := include "helm-chart-library.default-check-required-msg" . -}}
resources:
  requests:
    memory: {{ required (printf $requiredMsg "container.requestMemory") .requestMemory | quote }}
    cpu: {{ required (printf $requiredMsg "container.requestCpu") .requestCpu | quote }}
  limits:
    memory: {{ required (printf $requiredMsg "container.limitMemory") .limitMemory | quote }}
    cpu: {{ required (printf $requiredMsg "container.limitCpu") .limitCpu | quote }}
{{- end}}