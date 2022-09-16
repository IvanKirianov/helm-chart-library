{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "helm-chart-library.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "helm-chart-library.labels" -}}
helm.sh/chart: {{ include "helm-chart-library.chart" . }}
{{ include "helm-chart-library.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "helm-chart-library.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helm-chart-library.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Values.component }}
app.kubernetes.io/component: {{ .Values.component }}
{{- end }}
{{- $global := ternary .Global .Values (hasKey . "Global") }}
app.kubernetes.io/product: {{ default (include "helm-chart-library.name" .) $global.product }}
{{- if $global.maintainer }}
app.kubernetes.io/maintainer: {{ $global.maintainer }}
{{- end }}
{{- end }}