# https://github.com/microsoft/AKS-HCI-Apps/tree/main/nginx-ingress
# https://kubernetes.github.io/ingress-nginx/deploy/

# install
kubectl apply -f ./yaml/ingress.yaml

# kubectl delete -f ./yaml/ingress.yaml

# verify
kubectl get pods --all-namespaces -l app.kubernetes.io/name=ingress-nginx --watch

# install nginx service
kubectl apply -f ./yaml/nginx-service.yaml

kubectl get svc -n ingress-nginx

# deploy cafe application

kubectl config set-context $(kubectl config current-context) --namespace=ingress-nginx

kubectl apply -f ./yaml/cafe.yaml
kubectl apply -f ./yaml/cafe-secret.yaml
kubectl apply -f ./yaml/cafe-ingress.yaml

# kubectl delete -f ./yaml/cafe.yaml
# kubectl delete -f ./yaml/cafe-secret.yaml
# kubectl delete -f ./yaml/cafe-ingress.yaml

kubectl get pods

$IC_IP="10.0.0.102" # ip is from kubectl get svc -n ingress-nginx ingress-nginx EXTERNAL-IP
$IC_HTTPS_PORT=443

curl.exe --resolve cafe.lab.local:$($IC_HTTPS_PORT):$($IC_IP) "https://cafe.lab.local:$($IC_HTTPS_PORT)/coffee" --insecure
curl.exe --resolve cafe.lab.local:$($IC_HTTPS_PORT):$($IC_IP) "https://cafe.lab.local:$($IC_HTTPS_PORT)/coffee" --insecure
curl.exe --resolve cafe.lab.local:$($IC_HTTPS_PORT):$($IC_IP) "https://cafe.lab.local:$($IC_HTTPS_PORT)/tea" --insecure
curl.exe --resolve cafe.lab.local:$($IC_HTTPS_PORT):$($IC_IP) "https://cafe.lab.local:$($IC_HTTPS_PORT)/tea" --insecure

# set default namespace
kubectl config set-context $(kubectl config current-context) --namespace=default
