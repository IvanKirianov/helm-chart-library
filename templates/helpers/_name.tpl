{{/*
Expand the name of the chart.
*/}}
{{- define "helm-chart-library.name" -}}
{{- $requiredMsg := include "helm-chart-library.default-check-required-msg" . -}}
{{- $global := ternary .Global .Values (hasKey . "Global") -}}
{{/*- $appName := ((regexFind "(.+)[-]" .Chart.Name) | trimSuffix "-")*/}}
{{- $appName := .Chart.Name }}
{{- if .IsMany }}
    {{- printf "%s-%s-%s" $appName (required (printf $requiredMsg "component") .Values.component) (default "" $global.environment)  | trunc 63 | trimSuffix "-" | lower }}
{{- else }}
    {{- printf "%s-%s-%s" $appName (default "" .Values.component) (default "" $global.environment) | trunc 63  | replace "--" "-" | trimSuffix "-" | lower }}
{{- end }}
{{- end }}