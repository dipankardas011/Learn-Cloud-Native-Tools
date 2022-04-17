{{- define "mychart.app" -}}
app_name: {{ .Chart.Name | quote }}
app_version: {{ .Chart.Version | quote }}
{{- end -}}
