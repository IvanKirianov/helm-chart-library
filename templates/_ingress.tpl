{{- define "helm-chart-library.ingress" -}}
{{- if .Values.ingress -}}
{{- if .Values.ingress.enabled -}}
{{- if default true .Values.ingress.uselibrary -}}
{{- $requiredMsg := include "helm-chart-library.default-check-required-msg" . -}}
{{- $global := (ternary .Global .Values (hasKey . "Global"))}}
{{- $name := include "helm-chart-library.name" . }}
{{- $url := printf "%s.%s" $name (required (printf $requiredMsg ".Values.host") $global.host) }}
---
{{- $svcPort := include "helm-chart-library.serviceport" . -}}
{{- if semverCompare ">=1.21-0" .Capabilities.KubeVersion.GitVersion -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ $name }}-ingress
  labels:
    {{- include "helm-chart-library.labels" . | nindent 4 }}
  {{- with .Values.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  ingressClassName: {{ default "ngnix" .Values.ingress.class }}
  {{- if default true .Values.ingress.tls }}
  tls:
    - hosts:
        - {{ default $url .Values.ingress.host }}
      {{- if .Values.secretName }}
      secretName: {{ .Values.secretName }}
      {{- end }}
  {{- end }}
  rules:
    - host: {{ default $url .Values.ingress.host }}
      http:
        paths:
          - path: {{ default "/" .Values.ingress.path }}
            pathType: Prefix
            backend:
              service:
                name: {{ $name }}-service
                port:
                  number: {{ $svcPort }}
{{- else -}}
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: {{ $name }}-ingress
  labels:
    {{- include "helm-chart-library.labels" . | nindent 4 }}
  {{- with .Values.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if default true .Values.ingress.tls }}
  tls:
    - hosts:
        - {{ default $url .Values.ingress.host }}
      {{- if .Values.secretName }}
      secretName: {{ .Values.secretName }}
      {{- end }}
  {{- end }}
  rules:
    - host: {{ default $url .Values.ingress.host }}
      http:
        paths:
          - path: {{ default "/" .Values.ingress.path }}
            backend:
              serviceName: {{ $name }}-service
              servicePort: {{ $svcPort }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}