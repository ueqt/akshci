# https://docs.microsoft.com/en-us/azure-stack/aks-hci/persistent-volume
# https://docs.microsoft.com/en-us/azure-stack/aks-hci/container-storage-interface-disks

kubectl create -f ./yaml/linuxonce.yaml

kubectl get storageclass

kubectl get pvc

kubectl get pods -o wide

# kubectl delete -f ./yaml/linuxonce.yaml