# https://github.com/kubernetes-csi/csi-driver-smb/blob/master/deploy/example/e2e_usage.md

kubectl apply -f ./yaml/windowsmany.yaml

kubectl get storageclass

kubectl get pvc

kubectl describe pvc windowsmany-pvc

kubectl get pv

kubectl get pods -o wide

kubectl describe pod windowsmany-pod1

kubectl describe pod windowsmany-pod2

# kubectl exec -it <win-webserver-xxx> cmd.exe

# dir
# cd /mnt
# cd akshciscsi
# echo "1" > 1.txt
# dir

# kubectl delete -f ./yaml/windowsmany.yaml