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

## What's included

* latest Traefik (following the [master branch](https://github.com/traefik/traefik/tree/master/)) and [Panther](https://github.com/valerauko/panther) (for Let's Encrypt DNS-01 challenge)
* Longhorn (as default persistence)
* Prometheus, Loki, Grafana, metrics-server
* Argo CD (for automation and managing all the above)

## Credit

The cover photo is by <a href="https://unsplash.com/@aewild?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Amanda Frank</a> on <a href="https://unsplash.com/s/photos/fox?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>.
