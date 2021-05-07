#!/bin/bash

set -euo pipefail

ROKA_ROOT=$(dirname $(realpath $0))

read -erp $'What\'s your Civo API token? (From https://www.civo.com/account/security)\n' TOKEN
if [ -z "$TOKEN" ]; then
  echo 'API token is required.'
  exit 1
fi

read -erp $'\nWhat\'s your Civo API region? (Default LON1)\n' REGION
REGION=${REGION:=LON1}

read -erp $'\nWhat\'s your email address? (required for domain certificates)\n' EMAIL
if [ -z "$EMAIL" ]; then
  echo 'Email is required.'
  exit 1
fi

read -erp $'\nWhat domain to use?\n' DOMAIN
if [ -z "$DOMAIN" ]; then
  echo 'Domain is required.'
  exit 1
fi

echo

set -x

# mark civo's storageclass as not-default (want to use bootstrapped longhorn)
kubectl annotate storageclass civo-volume storageclass.kubernetes.io/is-default-class-

# install with the name "argo-cd" so that argo can later manage itself
helm install \
  --set email="$EMAIL" \
  --set domain="$DOMAIN" \
  --set apiToken="$TOKEN" \
  --set region="$REGION" \
  -n argo-cd --create-namespace \
  argo-cd "$ROKA_ROOT/manual"

set +x

echo
echo "Waiting for Argo CD to come online..."

while ! kubectl -n argo-cd get secret argocd-initial-admin-secret >/dev/null 2>/dev/null; do
  sleep 3
done

ARGO_PASS=$(kubectl -n argo-cd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
kubectl -n argo-cd delete secret argocd-initial-admin-secret

echo "Your Argo CD password is $ARGO_PASS"

echo
echo "Waiting for Grafana to come online... (this can take a while)"

while ! kubectl get secret -n monitoring grafana >/dev/null 2>/dev/null; do
  sleep 3
done

GRAFANA_PASS=$(kubectl get secret -n monitoring grafana -o jsonpath="{.data.admin-password}" | base64 -d)

echo "Your Grafana password is $GRAFANA_PASS"
echo
echo "All set! Happy foxing on Civo!"
echo
