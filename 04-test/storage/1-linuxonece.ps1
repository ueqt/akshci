# https://docs.microsoft.com/en-us/azure-stack/aks-hci/persistent-volume
# https://docs.microsoft.com/en-us/azure-stack/aks-hci/container-storage-interface-disks

# failed to provision volume with StorageClass "default": rpc error: code = DeadlineExceeded desc = context deadline exceeded
# restart VM and rerun

kubectl apply -f ./yaml/linuxonce.yaml

kubectl get storageclass

kubectl get pvc

kubectl describe pvc linuxonce-pvc

kubectl get pods -o wide

kubectl exec -it linuxonce-pvc /bin/bash

# cd /data
# touch 1.txt
# ls

# kubectl delete -f ./yaml/linuxonce.yaml