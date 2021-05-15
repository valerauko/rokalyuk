# Rokalyuk 🦊 example

This is an example for deploying something using Argo CD.

## Argo

The [Application manifest](example/argo/example.yaml) describes where should Argo CD look for your application (eg its Kubernetes manifests or Helm chart).

Check out [Argo CD's documentation](https://argoproj.github.io/argo-cd/operator-manual/declarative-setup) or look at [the Applications Rokalyuk uses](apps/templates).

## K8s

The [Kubernetes manifests](example/k8s) of this example. A Deployment, an Ingress and a Service are a minimal setup for releasing a website on Kubernetes.

The [image in the Deployment](example/k8s/deployment.yaml#L22) and the [domain in the Ingress](example/k8s/ingress.yaml#L13-L15) are the first places to look for customization.

## Dockerfile

The [Dockerfile](example/Dockerfile) just adds the site's HTML to the [nginx:alpine](https://hub.docker.com/_/nginx/) image. It might seem excessive but you do need a way to launch that HTML into a web server container...

## index.html

A [static HTML page](example/index.html) to greet your visitors.
