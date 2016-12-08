# minikube-bzzd-env
Simple dev environment for bzzd simulations

## Usage

Install `minikube` and `kubectl`

Set the `AUTOGENKEYS` flag in `startLocal.sh` to choose whether the container auto-generates geth keys, or imports them from `secrets/geth`. 

To setup the environment, simply run

```bash
chmod +x startlocal.sh && ./startlocal.sh
```
