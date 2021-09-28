# https://github.com/microsoft/ctsTraffic

kubectl apply -f ./yaml/ctstraffic.yaml
# kubectl delete -f ./yaml/ctstraffic.yaml

kubectl describe pod ctstraffic-reciever

kubectl logs ctstraffic-reciever

kubectl get pods -o wide

kubectl exec ctstraffic-sender -it -- /cmd
# ctstraffic -target:<targetIp> -transfer:0x10000000 -connections:100 -iterations:1000
