{{- define "helm-chart-library.deployment" -}}
{{- $requiredMsg := include "helm-chart-library.default-check-required-msg" . -}}
{{- $global := (ternary .Global .Values (hasKey . "Global"))}}
{{- $name := include "helm-chart-library.name" . }}
{{- $files := .Files }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $name }}-deployment
  labels:
    {{- include "helm-chart-library.labels" . | nindent 4 }}
spec:
  {{- if eq "false" (include "helm-chart-library.dig" (dict "map" .Values "key" "autoscaling.enabled" "default" "false")) }}
  replicas: {{ if kindIs "float64" .Values.replicas }}{{ .Values.replicas }}{{ else }}{{ 1 }}{{ end }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "helm-chart-library.selectorLabels" . | nindent 6 }}
  template:
    metadata:
     {{- with .Values.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      labels:
        {{- include "helm-chart-library.selectorLabels" . | nindent 8 }}
    spec:
      {{- if .Values.imagePullSecrets }}
      imagePullSecrets:
        - name: {{ .Values.imagePullSecrets | quote }}
      {{- end }}
      securityContext:
        {{- if .Values.runAsUser }}
        fsGroup: {{ .Values.runAsUser }}
        runAsUser: {{ .Values.runAsUser }}
        {{- end }}
        runAsNonRoot:  false
      {{- if .Values.hostAliases }}
      hostAliases:
        {{- toYaml .Values.hostAliases | nindent 8 -}}
      {{- end }}
      containers:
      {{- $chart := .Chart }}
      {{- range $idx, $container := .Values.containers }}
      {{- $containerType := "standard" }}
      {{- $data := dict "Global" $global "Chart"  $chart "Files" $files "Container" $container "ContainerType" $containerType "Name" $name }}
        {{- include "helm-chart-library.containers" $data | nindent 8 }}
      {{- end }}
      initContainers:
      {{- range $idx, $container := .Values.initContainers }}
      {{- $containerType := "init" }}
      {{- $data := dict "Global" $global "Chart"  $chart "Files" $files "Container" $container "ContainerType" $containerType "Name" $name }}
        {{- include "helm-chart-library.containers" $data | nindent 8 }}
      {{- end }}
      {{- with .Values.volumes }}
      volumes:
      {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
{{- end }}