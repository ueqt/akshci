# https://ithelp.ithome.com.tw/articles/10195094

kubectl apply -f ./yaml/secret.yaml

kubectl get secret

kubectl get pods my-pod

kubectl exec -it my-pod -- /bin/bash

# echo $SECRET_USERNAME
# echo $SECRET_PASSWORD

# kubectl delete -f ./yaml/secret.yaml