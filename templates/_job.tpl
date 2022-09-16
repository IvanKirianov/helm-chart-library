{{- define "helm-chart-library.job" -}}
{{- $requiredMsg := include "helm-chart-library.default-check-required-msg" . -}}
{{- $global := (ternary .Global .Values (hasKey . "Global"))}}
{{- $name := include "helm-chart-library.name" . }}
{{- $files := .Files }}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ $name }}-job
  {{- with .Values.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  labels:
    {{- include "helm-chart-library.labels" . | nindent 4 }}
spec:
  backoffLimit: {{ .Values.backoffLimit | default 2 }}
  template:
    spec:
      restartPolicy: {{ .Values.restartPolicy | default "Never" }}
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
      containers:
      {{- $chart := .Chart }}
      {{- range $idx, $container := .Values.containers }}
      {{- $containerType := "job" }}
      {{- $data := dict "Global" $global "Chart"  $chart "Files" $files "Container" $container "ContainerType" $containerType "Name" $name }}
        {{- include "helm-chart-library.containers" $data | nindent 8 }}
      {{- end }}
      initContainers:
      {{- range $idx, $container := .Values.initContainers }}
      {{- $containerType := "init" }}
      {{- $data := dict "Global" $global "Chart"  $chart "Files" $files "Container" $container "ContainerType" $containerType }}
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
{{- end}}