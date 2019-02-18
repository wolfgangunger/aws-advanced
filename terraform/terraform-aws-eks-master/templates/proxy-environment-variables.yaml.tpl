apiVersion: v1
kind: ConfigMap
metadata:
  name: proxy-environment-variables
  namespace: kube-system
data:
  HTTP_PROXY: ${http_proxy}
  HTTPS_PROXY: ${https_proxy}
  NO_PROXY: ${no_proxy}
  http_proxy: ${http_proxy}
  https_proxy: ${https_proxy}
  no_proxy: ${no_proxy}