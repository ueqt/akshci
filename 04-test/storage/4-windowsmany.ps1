# https://github.com/kubernetes-csi/csi-driver-smb/blob/master/deploy/example/e2e_usage.md

kubectl apply -f ./yaml/windowsmany.yaml

kubectl get storageclass

kubectl get pvc

kubectl describe pvc windowsmany-pvc

kubectl get pv

kubectl get pods -o wide

kubectl describe pod windowsmany-pod1

kubectl describe pod windowsmany-pod2

kubectl exec windowsmany-pod1 -it -- cmd.exe

# dir
# cd data
# echo "1" > 1.txt
# dir

kubectl exec windowsmany-pod2 -it -- cmd.exe

# dir
# cd data
# dir
# cat 1.txt

# kubectl delete -f ./yaml/windowsmany.yaml