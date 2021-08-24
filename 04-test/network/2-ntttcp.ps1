# https://docs.azure.cn/zh-cn/virtual-network/virtual-network-bandwidth-testing

kubectl apply -f ./yaml/ntttcp.yaml

kubectl describe pod ntttcp-linux-sender

kubectl logs ntttcp-linux-reciever

kubectl get pods -o wide

kubectl exec ntttcp-linux-sender -it -- /bin/bash

# ntttcp -s<reciverip> -t 300 -V

kubectl logs ntttcp-linux-sender

# kubectl delete -f ./yaml/ntttcp.yaml

# On linux VM with docker

docker run -p 5000-5200:5000-5200 ueqt/ntttcp:linux

# curl -o C:\NTttcp.exe https://github.com/microsoft/ntttcp/releases/download/v5.36/NTttcp.exe

kubectl apply -f ./yaml/ntttcp-service.yaml

kubectl get svc

# On mgmt
# download https://github.com/microsoft/ntttcp
ntttcp -s -m 8,*,<Cluster IP> -t 300 -v

kubectl logs ntttcp-linux-reciever -f