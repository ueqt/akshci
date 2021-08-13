# https://github.com/kubernetes-csi/csi-driver-smb/blob/master/docs/csi-debug.md
# https://github.com/Azure/aks-hci/issues/116

kubectl get po -o wide -n kube-system | grep csi-smb-controller

# check cifs mount inside driver
kubectl exec csi-smb-node-xxxx -n kube-system -c smb -- mount | grep cifs

# if not exist
kubectl exec csi-smb-controller-xxxx -n kube-system -c smb -- apt install -y cifs-utils
