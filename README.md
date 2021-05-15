# Rokalyuk 🦊

![Fox](https://repository-images.githubusercontent.com/364476568/b565c900-af60-11eb-8c7a-372d25bda048)

Rokalyuk ("fox den" in Hungarian) is a way to get your cluster up and running on Civo quickly.

## Usage

1. clone this repo
1. run `install.sh` and answer the questions

### Requirements

You'll need the following installed for the script to run.

* helm
* kubectl

## Deploying applications

If you have multiple applications running in your cluster, it's recommended to use the ["app of apps" pattern](https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/#app-of-apps) and have Argo CD roll out everything for you declaratively. You would manually add an Application that points to a git folder with your other Application definitions.

However, if you only have one, then create an Application for it and go! There's an [example](example) for reference.

## What's included

* latest Traefik and [Panther](https://github.com/valerauko/panther) (for Let's Encrypt DNS-01 challenge)
* Longhorn (as default persistence)
* Prometheus, Loki, Grafana, metrics-server
* Argo CD (for automation and managing all the above)

## What it does for you

* provision wildcard domain certificates (valid for any subdomain)
* keep the components listed above up-to-date

## Credit

The cover photo is by <a href="https://unsplash.com/@aewild?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Amanda Frank</a> on <a href="https://unsplash.com/s/photos/fox?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>.
