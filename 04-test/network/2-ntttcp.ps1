# https://docs.azure.cn/zh-cn/virtual-network/virtual-network-bandwidth-testing

kubectl apply -f ./yaml/ntttcp.yaml

kubectl describe pod ntttcp-linux-sender

kubectl logs ntttcp-linux-reciever

kubectl get pods -o wide

kubectl exec ntttcp-linux-sender -it -- /bin/bash

# ntttcp -s<recieverip> -t 300 -V
# to windows
# ntttcp -s<recieverip> -t 300 -V -m 8,*,<recieverip> -N

kubectl logs ntttcp-linux-sender

# kubectl delete -f ./yaml/ntttcp.yaml

# On linux VM with docker

docker run -p 5000-5200:5000-5200 ueqt/ntttcp:linux

# curl -o C:\NTttcp.exe https://github.com/microsoft/ntttcp/releases/download/v5.36/NTttcp.exe

# On mgmt
# download https://github.com/microsoft/ntttcp
# windows must close firewall
netsh advfirewall firewall add rule program=c:\adsso\ntttcp.exe name="ntttcp" protocol=any dir=in action=allow enable=yes profile=ANY
ntttcp -s -m 8,*,<Cluster IP> -t 300 -v -ns

kubectl logs ntttcp-linux-reciever -f

# windows reciever
ntttcp -r -m 8,*,0.0.0.0 -v
