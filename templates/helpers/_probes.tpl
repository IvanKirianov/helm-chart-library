{{/*Template for probes arcording to architecture chapter*/}}
{{- define "helm-chart-library.probes" -}}
{{- if (hasKey . "probes")}}
  {{- if or (.probes.enabled) (eq (.probes.enabled | toString) "<nil>") }}
    {{- include "helm-chart-library.sub-probe" . }}
  {{- end }}
  {{- else }}
    {{- include "helm-chart-library.sub-probe" . }}
  {{- end }}
{{- end }}

{{/* Probes caller */}}
{{- define "helm-chart-library.sub-probe" -}}
livenessProbe:
  httpGet:
    path: /ping
    port: http
  initialDelaySeconds: {{ include "helm-chart-library.dig" (dict "map" . "key" ".probes.livenessDelaySeconds" 30) }}
  periodSeconds: 15
  timeoutSeconds: 1
readinessProbe:
  httpGet:
    path: /health
    port: http
  initialDelaySeconds: {{ include "helm-chart-library.dig" (dict "map" . "key" ".probes.readinessDelaySeconds" 90) }}
  periodSeconds: 60
  timeoutSeconds: 5
{{- end }}