{{- define "helm-chart-library.cronjob" -}}
{{- $requiredMsg := include "helm-chart-library.default-check-required-msg" . -}}
{{- $global := (ternary .Global .Values (hasKey . "Global"))}}
{{- $name := include "helm-chart-library.name" . }}
{{- $files := .Files }}

---
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: {{ $name }}-cronjob
  {{- with .Values.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  labels:
    {{- include "helm-chart-library.labels" . | nindent 4 }}
spec:
{{/*
This schedule means that it will never run, as this date is 30 of February - designed by default, can be overriden on consumer side
*/}}
  schedule: {{ .Values.schedule | default "0 0 30 2 0" }}
  failedJobsHistoryLimit: {{ .Values.failedJobsHistoryLimit | default 1 }}
  successfulJobsHistoryLimit: {{ .Values.successfulJobsHistoryLimit | default 1 }}
  concurrencyPolicy: {{ .Values.schedule | default "Replace" }}
  jobTemplate:
    spec:
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
            {{- include "helm-chart-library.containers" $data | nindent 12 }}
          {{- end }}
          initContainers:
          {{- range $idx, $container := .Values.initContainers }}
          {{- $containerType := "init" }}
          {{- $data := dict "Global" $global "Chart"  $chart "Files" $files "Container" $container "ContainerType" $containerType }}
            {{- include "helm-chart-library.containers" $data | nindent 12 }}
          {{- end }}
          {{- with .Values.volumes }}
          {{- end }}
          {{- with .Values.volumes }}
          volumes:
          {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with .Values.nodeSelector }}
          nodeSelector:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with .Values.affinity }}
          affinity:
            {{- toYaml . | nindent 12 }}
          {{- end }}
          {{- with .Values.tolerations }}
          tolerations:
            {{- toYaml . | nindent 12 }}
          {{- end }}
{{- end}}