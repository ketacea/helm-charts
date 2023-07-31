{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ketadb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "ketadb.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ketadb.uname" -}}
{{- if empty .Values.fullnameOverride -}}
{{- if empty .Values.nameOverride -}}
{{ .Values.clusterName }}
{{- else -}}
{{ .Values.nameOverride }}
{{- end -}}
{{- else -}}
{{ .Values.fullnameOverride }}
{{- end -}}
{{- end -}}

{{- define "ketadb.masterService" -}}
{{- if empty .Values.masterService -}}
{{- if empty .Values.fullnameOverride -}}
{{- if empty .Values.nameOverride -}}
{{ .Values.clusterName }}-master
{{- else -}}
{{ .Values.nameOverride }}-master
{{- end -}}
{{- else -}}
{{ .Values.fullnameOverride }}
{{- end -}}
{{- else -}}
{{ .Values.masterService }}
{{- end -}}
{{- end -}}

{{- define "ketadb.endpoints" -}}
{{- $replicas := int (toString (.Values.replicas)) }}
{{- $uname := printf "%s-%s" .Values.clusterName .Values.nodeGroup }}
  {{- range $i, $e := untilStep 0 $replicas 1 -}}
{{ $uname }}-{{ $i }},
  {{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for statefulset.
*/}}
{{- define "ketadb.statefulset.apiVersion" -}}
{{- if semverCompare "<1.9-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "apps/v1beta2" -}}
{{- else -}}
{{- print "apps/v1" -}}
{{- end -}}
{{- end -}}

{{- define "ketadb.kubeVersion" -}}
  {{- default .Capabilities.KubeVersion.Version .Values.kubeVersionOverride -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "ketadb.ingress.apiVersion" -}}
  {{- if and (.Capabilities.APIVersions.Has "networking.k8s.io/v1") (semverCompare ">= 1.19-0" (include "ketadb.kubeVersion" .)) -}}
  {{- print "networking.k8s.io/v1" -}}
  {{- else if .Capabilities.APIVersions.Has "networking.k8s.io/v1beta1" -}}
    {{- print "networking.k8s.io/v1beta1" -}}
  {{- else -}}
    {{- print "extensions/v1beta1" -}}
  {{- end -}}
{{- end -}}

{{- define "ketadb.ingress.isStable" -}}
  {{- eq (include "ketadb.ingress.apiVersion" .) "networking.k8s.io/v1" -}}
{{- end -}}

{{- define "ketadb.ingress.supportsPathType" -}}
  {{- or (eq (include "ketadb.ingress.isStable" .) "true") (and (eq (include "ketadb.ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18-0" (include "ketadb.kubeVersion" .))) -}}
{{- end -}}

{{- define "pandora.web.svc.name" -}}
{{- if empty .Values.fullnameOverride -}}
{{- if empty .Values.nameOverride -}}
pandora-web-svc
{{- else -}}
{{ .Values.nameOverride }}
{{- end -}}
{{- else -}}
{{ .Values.fullnameOverride }}
{{- end -}}
{{- end -}}


{{/*
Expand the name of the chart.
*/}}
{{- define "keta-ml.name" -}}
{{- default .Chart.Name .Values.ketaML.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "keta-ml.fullname" -}}
{{- if .Values.ketaML.fullnameOverride }}
{{- .Values.ketaML.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- default .Chart.Name .Values.ketaML.nameOverride }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "keta-ml.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "keta-ml.labels" -}}
helm.sh/chart: {{ include "keta-ml.chart" . }}
{{ include "keta-ml.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "keta-ml.selectorLabels" -}}
app.kubernetes.io/name: {{ include "keta-ml.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

