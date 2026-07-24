{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper vaultwarden image name
*/}}
{{- define "vaultwarden.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "vaultwarden.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "vaultwarden.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the CNP cluster fullname
*/}}
{{- define "vaultwarden.cnp.fullname" -}}
{{- if .Values.postgresql.name -}}
{{- .Values.postgresql.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-postgresql" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the CNP cluster service name (read-write)
*/}}
{{- define "vaultwarden.cnp.serviceName" -}}
{{- printf "%s-rw" (include "vaultwarden.cnp.fullname" .) -}}
{{- end -}}

{{/*
Return the CNP secret name
*/}}
{{- define "vaultwarden.cnp.secretName" -}}
{{- if .Values.postgresql.database.existingSecret -}}
{{- .Values.postgresql.database.existingSecret -}}
{{- else -}}
{{- printf "%s-app" (include "vaultwarden.cnp.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the CNP database password
*/}}
{{- define "vaultwarden.cnp.password" -}}
{{- $secretData := (lookup "v1" "Secret" $.Release.Namespace (include "vaultwarden.cnp.secretName" .)).data }}
{{- if and $secretData (hasKey $secretData "password") }}
{{- index $secretData "password" | b64dec }}
{{- else }}
{{- randAlphaNum 16 }}
{{- end }}
{{- end -}}

{{/*
Get the database host
*/}}
{{- define "vaultwarden.database.host" -}}
{{- if .Values.postgresql.enabled -}}
{{- $releaseNamespace := .Release.Namespace }}
{{- $clusterDomain := .Values.clusterDomain }}
{{- $serviceName := include "vaultwarden.cnp.serviceName" . }}
{{- printf "%s.%s.svc.%s" $serviceName $releaseNamespace $clusterDomain -}}
{{- else -}}
{{- .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Get the database port
*/}}
{{- define "vaultwarden.database.port" -}}
{{- if .Values.postgresql.enabled -}}
5432
{{- else -}}
{{- .Values.externalDatabase.port -}}
{{- end -}}
{{- end -}}

{{/*
Get the database name
*/}}
{{- define "vaultwarden.database.name" -}}
{{- if .Values.postgresql.enabled -}}
{{- .Values.postgresql.database.name -}}
{{- else -}}
{{- .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Get the database username
*/}}
{{- define "vaultwarden.database.username" -}}
{{- if .Values.postgresql.enabled -}}
{{- .Values.postgresql.database.username -}}
{{- else -}}
{{- .Values.externalDatabase.username -}}
{{- end -}}
{{- end -}}

{{/*
Get the Postgresql credentials secret.
*/}}
{{- define "vaultwarden.databaseSecretName" -}}
{{- if .Values.postgresql.enabled -}}
{{- include "vaultwarden.cnp.secretName" . -}}
{{- else -}}
{{- default (printf "%s-externaldb" .Release.Name) (tpl .Values.externalDatabase.existingSecret $) -}}
{{- end -}}
{{- end -}}

{{/*
Add environment variables to configure database values
*/}}
{{- define "vaultwarden.databaseSecretKey" -}}
{{- if .Values.postgresql.enabled -}}
    {{- print "password" -}}
{{- else -}}
    {{- if .Values.externalDatabase.existingSecret -}}
        {{- if .Values.externalDatabase.existingSecretPasswordKey -}}
            {{- printf "%s" .Values.externalDatabase.existingSecretPasswordKey -}}
        {{- else -}}
            {{- print "password" -}}
        {{- end -}}
    {{- else -}}
        {{- print "password" -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS credentials secret object should be created
*/}}
{{- define "vaultwarden.createTlsSecret" -}}
{{- if and (not .Values.tls.existingSecret) .Values.tls.enabled }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the TLS secret name
*/}}
{{- define "vaultwarden.issuerName" -}}
{{- $issuerName := .Values.tls.issuerRef.existingIssuerName -}}
{{- if $issuerName -}}
    {{- printf "%s" (tpl $issuerName $) -}}
{{- else -}}
    {{- printf "%s-http" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}
