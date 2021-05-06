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

kubectl apply -f "$ROKA_ROOT/manual/02-system.yaml"

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

kubectl apply $K8S_DRY -f "$ROKA_ROOT/manual/04-bootstrap.yaml"

set +x

echo
echo "All set!"
