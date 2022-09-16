{{- define "helm-chart-library.service" -}}
{{- if .Values.service -}}
{{- if .Values.service.enabled -}}
{{- $name := include "helm-chart-library.name" . }}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ $name }}-service
  labels:
    {{- include "helm-chart-library.labels" . | nindent 4 }}
  {{- with .Values.service.annotations }}
  annotations:
    {{- toYaml . | nindent 8 }}
  {{- end }}
spec:
  type: {{ default "ClusterIP" .Values.service.type }}
  {{- if .Values.service.clusterIP }}
  clusterIP: {{ .Values.service.clusterIP }}
  {{end}}
  ports:
    - port: {{ include "helm-chart-library.serviceport" . }}
      targetPort: {{default 80 .Values.service.targetPort}}
      protocol: TCP
      name: {{ include "helm-chart-library.serviceport" . }}-{{ $name }}-service
    {{- if .Values.service.extraPorts}}
    {{- toYaml .Values.service.extraPorts | nindent 4 }}
    {{- end }}
  selector:
    {{- include "helm-chart-library.selectorLabels" . | nindent 6 }}
{{- end }}
{{- end }}
{{- end }}
{{- define "helm-chart-library.serviceport" -}}
{{default 80 .Values.service.port}}
{{- end }}