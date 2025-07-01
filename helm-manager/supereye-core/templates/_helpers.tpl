{{- define "iot-phoneDevice.name" -}}
iot-phoneDevice
{{- end -}}

{{- define "iot-phoneDevice.fullname" -}}
{{ printf "%s" (include "iot-phoneDevice.name" .) }}
{{- end -}}