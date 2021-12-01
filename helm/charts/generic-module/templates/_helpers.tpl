{{- define "imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": { \"username\":\"%s\",\"password\":\"%s\",\"auth\":\"%s\"}}}" .Values.imageCredentials.registry .Values.imageCredentials.username .Values.imageCredentials.accessToken (printf "%s:%s" .Values.imageCredentials.username .Values.imageCredentials.accessToken | b64enc) | b64enc }}
{{- end }}
{{- define "imagePullSecretName" }}
{{- printf "docker-registry-github-%s" .Values.appName }}
{{- end }}