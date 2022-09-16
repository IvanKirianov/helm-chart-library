{{/*
Goes through the list of deployments and calls subtemplates
*/}}
{{- define "helm-chart-library.entrypoint" -}}
    {{- $myApp := .MyApplication -}}
    {{- $release := .BuiltIn.Release -}}
    {{- $chart := .BuiltIn.Chart -}}
    {{- $files := .BuiltIn.Files -}}
    {{- $template := .BuiltIn.Template -}}
    {{- $capabilities := .BuiltIn.Capabilities -}}
    {{- if $myApp.deployments }}
        {{ $deploymentCount := len $myApp.deployments }}
        {{- $isMany := ternary true false (gt $deploymentCount 1) -}}
        {{- range $idx, $val := $myApp.deployments }}
            {{- if or $val.enabled (not (hasKey $val "enabled"))}}
                {{- $data := dict "Values" $val "Chart" $chart "Release" $release "Files" $files "Template" $template "Capabilities" $capabilities "Global" $myApp "Index" $idx "IsMany" $isMany }}
                {{- include "helm-chart-library.deploymentcaller" $data }}
            {{- end }}
        {{- end }}
    {{- end }}
    {{- if $myApp.jobs }}
        {{ $jobCount := len $myApp.jobs }}
        {{- $isMany := ternary true false (gt $jobCount 1) -}}
        {{- range $idx, $val := $myApp.jobs }}
            {{- $data := dict "Values" $val "Chart" $chart "Release" $release "Files" $files "Template" $template "Capabilities" $capabilities "Global" $myApp "Index" $idx "IsMany" $isMany }}
            {{- include "helm-chart-library.jobcaller" $data }}
        {{- end }}
    {{- end }}
    {{- if $myApp.configmaps }}
        {{ $configMapCount := len $myApp.configmaps }}
        {{- $isMany := ternary true false (gt $configMapCount 1) -}}
        {{- range $idx, $val := $myApp.configmaps }}
            {{- $data := dict "Values" $val "Chart" $chart "Release" $release "Files" $files "Template" $template "Capabilities" $capabilities "Global" $myApp "Index" $idx "IsMany" $isMany }}
            {{- include "helm-chart-library.configmapcaller" $data }}
        {{- end }}
    {{- end }}
    {{- if $myApp.cronjobs }}
        {{ $cronjobCount := len $myApp.cronjobs }}
        {{- $isMany := ternary true false (gt $cronjobCount 1) -}}
        {{- range $idx, $val := $myApp.cronjobs }}
            {{- $data := dict "Values" $val "Chart" $chart "Release" $release "Files" $files "Template" $template "Capabilities" $capabilities "Global" $myApp "Index" $idx "IsMany" $isMany }}
            {{- include "helm-chart-library.cronjobcaller" $data }}
        {{- end }}
    {{- end }}
    {{- if $myApp.secrets }}
        {{- $data := dict "Values" $myApp.secrets "Chart" $chart "Release" $release "Files" $files "Template" $template "Capabilities" $capabilities "Global" $myApp  }}
        {{- include "helm-chart-library.secretcaller" $data }}
    {{- end }}

{{- end}}
{{/*
Calls the subtemplates within the given scopes
*/}}
{{- define "helm-chart-library.deploymentcaller" -}}
{{- include "helm-chart-library.configmap" . }}
{{- include "helm-chart-library.deployment" . }}
{{- include "helm-chart-library.hpa" . }}
{{- include "helm-chart-library.service" . }}
{{- include "helm-chart-library.ingress" . }}
{{- end}}
{{/*
Calls the subtemplates within the given scopes
*/}}
{{- define "helm-chart-library.jobcaller" -}}
{{- include "helm-chart-library.job" . }}
{{- include "helm-chart-library.configmap" . }}
{{- include "helm-chart-library.service" . }}
{{- end }}
{{/*
Calls the subtemplates within the given scopes
*/}}
{{- define "helm-chart-library.cronjobcaller" -}}
{{- include "helm-chart-library.cronjob" . }}
{{- include "helm-chart-library.configmap" . }}
{{- include "helm-chart-library.service" . }}
{{- end }}
{{/*
Calls the subtemplates within the given scopes
*/}}
{{- define "helm-chart-library.configmapcaller" -}}
{{- include "helm-chart-library.configmap" . }}
{{- end }}
{{/*
Calls the subtemplates within the given scopes
*/}}
{{- define "helm-chart-library.secretcaller" -}}
{{- include "helm-chart-library.secret" . }}
{{- end }}