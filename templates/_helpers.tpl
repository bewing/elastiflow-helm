{{/*
Return the proper elastiflow image name
*/}}
{{- define "elastiflow.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "elastiflow.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "elastiflow.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (printf "%s-foo" (include "common.names.fullname" .)) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message.
*/}}
{{- define "elastiflow.validateValues" -}}
{{- $messages := list -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message -}}
{{- end -}}
{{- end -}}
