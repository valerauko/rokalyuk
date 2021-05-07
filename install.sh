#!/bin/bash

set -euo pipefail

ROKA_ROOT=$(dirname $(realpath $0))

read -erp $'What\'s your Civo API token? (From https://www.civo.com/account/security)\n' TOKEN
if [ -z "$TOKEN" ]; then
  echo 'API token is required. Try again.'
  exit 1
fi

read -erp $'What\'s your Civo API region? (Default LON1)\n' REGION
REGION=${REGION:=LON1}

HELM_DRY=
K8S_DRY=

if [ $# == 1 ] && [ $1 == '--dry-run' ]; then
  HELM_DRY="--dry-run"
  K8S_DRY="--dry-run=client"
fi

set -x

kubectl apply $K8S_DRY -f "$ROKA_ROOT/manual/00-namespaces.yaml"

# 01
helm repo add argo https://argoproj.github.io/argo-helm
helm install $HELM_DRY --debug -n argo-cd argo-cd argo/argo-cd -f "$ROKA_ROOT/manual/argo-cd-values.yaml"

kubectl apply $K8S_DRY -f "$ROKA_ROOT/manual/02-system.yaml"

# 03
cat <<EOF | kubectl -n kube-system apply $K8S_DRY -f -
apiVersion: v1
kind: Secret
metadata:
  name: civo-api-secret
data:
  TOKEN: $(echo -n $TOKEN | base64)
  REGION: $(echo -n $REGION | base64)
EOF

# wait for argo secret to be created by helm before applying bootstrap
while ! kubectl -n argo-cd get secret argocd-initial-admin-secret 2>/dev/null; do
  sleep 1
done

ARGO_PASS=$(kubectl -n argo-cd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
kubectl -n argo-cd delete $K8S_DRY secret argocd-initial-admin-secret

# mark civo's storageclass as not-default (want to use bootstrapped longhorn)
kubectl annotate $K8S_DRY storageclass civo-volume storageclass.kubernetes.io/is-default-class-

kubectl apply $K8S_DRY -f "$ROKA_ROOT/manual/04-bootstrap.yaml"

echo
echo "All set! Your Argo CD password is $ARGO_PASS"
