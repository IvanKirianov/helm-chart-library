{{/*Template for containers arcording to architecture chapter*/}}
{{- define "helm-chart-library.containers" -}}
{{- $requiredMsg := include "helm-chart-library.default-check-required-msg" . -}}
{{- $test := required (printf $requiredMsg "container path or image") (.Container.image | default .Container.path) -}}
{{- $test := required (printf $requiredMsg "container path or name") (.Container.name | default .Container.path) -}}
{{- $containerImage := .Container.image | default (printf "%s%s%s:%s" .Global.containerRegistry (default "/" .Global.containerBasePath) .Container.path .Chart.AppVersion) -}}
{{- $containerName := .Container.name | default ((printf "%s-%s" (regexFind "([^/]+)/?$" (.Container.path | default "" )) "container") | replace "." "-") -}}
{{- $files := .Files -}}
{{- $name := .Name -}}
{{- $global := (ternary .Global .Values (hasKey . "Global")) -}}
{{- $chart := .Chart -}}
- name: {{ $containerName }}
  image: {{ $containerImage }}
  imagePullPolicy: {{ .Container.imagePullPolicy | default "IfNotPresent" }}
  securityContext:
    readOnlyRootFilesystem: false
    #readOnlyRootFilesystem: true
    allowPrivilegeEscalation: false
  {{- if eq .ContainerType "standard" }} #resources are required for deployment containers only?
  {{- $test := required (printf $requiredMsg "container resources") .Container.resources }}
    {{- include "helm-chart-library.resources" .Container.resources | nindent 2 }}
  {{- else }}
    {{- if .Container.resources }}
      {{- include "helm-chart-library.resources" .Container.resources | nindent 2 }}
    {{- end }}
  {{- end }}
  {{- if .Container.command }}
  command:
    {{- toYaml .Container.command | nindent 2 }}
  {{- end }}
  {{- if .Container.args }}
  args:
  {{- toYaml .Container.args | nindent 2 }}
  {{- end }}
  {{- if .Container.env }}
  env:
  {{- $env := merge (.Container.env | default dict) (.Global.env | default dict) -}}
  {{ range $k, $v := $env }}
    - name: {{ $k | quote }}
      value: {{ required (printf $requiredMsg $k) $v | quote }}
  {{- end }}
  {{- end }}
  {{- if .Container.secrets  }}
  {{- range $key, $val := .Container.secrets }}
    - name: {{ $key }}
      valueFrom:
        secretKeyRef:
          name: {{ printf "%s-%s-secret" $chart.Name (default "" $global.environment) | trunc 63 | replace "--" "-" | trimSuffix "-" }}
          key: {{ $val }}
  {{- end}}
  {{- end }}
  {{- if eq .ContainerType "standard" }}
  ports:
    - name: http
      containerPort: {{ default 80 .Container.port }}
      protocol: TCP
  {{- if .Container.extraPorts}}
  {{- toYaml .Container.extraPorts | nindent 4 }}
  {{- end }}
  {{- include "helm-chart-library.probes" .Container | nindent 2 -}}
  {{- end }}
  {{- with .Container.volumeMounts }}
  volumeMounts:
    {{- toYaml . | nindent 2 }}
  {{- end }}
{{- end }}