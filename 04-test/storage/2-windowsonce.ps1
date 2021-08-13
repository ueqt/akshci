# https://docs.microsoft.com/en-us/azure-stack/aks-hci/persistent-volume

kubectl apply -f ./yaml/windowsonce.yaml

kubectl get storageclass

kubectl get pvc

kubectl describe pvc windowsonce-pvc

kubectl get pods -o wide

# kubectl exec <win-webserver-xxx> -it -- cmd.exe

# dir
# cd /mnt
# cd akshciscsi
# echo "1" > 1.txt
# dir

# kubectl delete -f ./yaml/windowsonce.yaml