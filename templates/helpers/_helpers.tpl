{{/*
A default message string to be used when checking for a required value
*/}}
{{- define "helm-chart-library.default-check-required-msg" -}}
{{- "No value found for '%s' in helm-helm-chart-library template" -}}
{{- end -}}


{{/*
Helper method for nested values checks
*/}}
{{- define "helm-chart-library.dig" -}}
  {{- $mapToCheck := index . "map" -}}
  {{- $keyToFind := index . "key" -}}
  {{- $default := index . "default" -}}
  {{- $keySet := (splitList "." $keyToFind) -}}
  {{- $firstKey := first $keySet -}}
  {{- if index $mapToCheck $firstKey -}} {{/* The key was found */}}
    {{- if eq 1 (len $keySet) -}}{{/* The final key in the set implies we're done */}}
      {{- index $mapToCheck $firstKey -}}
    {{- else }}{{/* More keys to check, recurse */}}
      {{- include "helm-chart-library.dig" (dict "map" (index $mapToCheck $firstKey) "key" (join "." (rest $keySet)) "default" $default) }}
    {{- end }}
  {{- else }}{{/* The key was not found */}}
      {{- $default -}}
  {{- end }}
{{- end }}