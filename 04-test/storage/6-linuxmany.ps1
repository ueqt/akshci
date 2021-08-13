kubectl apply -f ./yaml/linuxmany.yaml

kubectl get storageclass

kubectl get pvc

kubectl describe pvc linuxmany-pvc

kubectl get pv

kubectl get pods -o wide

kubectl describe pod linuxmany-pod1

kubectl describe pod linuxmany-pod2

kubectl exec linuxmany-pod1 -it -- /bin/bash

# ls
# cd data
# echo "2" > 2.txt
# ls

kubectl exec linuxmany-pod2 -it -- /bin/bash

# ls
# cd data
# ls
# cat 2.txt

# kubectl delete -f ./yaml/linuxmany.yaml