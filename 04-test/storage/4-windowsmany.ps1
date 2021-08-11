# first create a share folder on this pc
# 共享名
$ShareName = 'share'
# 共享路径
$Path = 'c:\share'

New-Item -Force -ItemType directory -Path $Path
New-SmbShare -Name $ShareName -Path $Path -FullAccess everyone

kubectl apply -f ./yaml/windowsmany.yaml

kubectl get storageclass

kubectl get pvc

kubectl describe pvc windowsmany-pvc

kubectl get pods -o wide

# kubectl exec -it <win-webserver-xxx> cmd.exe

# dir
# cd /mnt
# cd akshciscsi
# echo "1" > 1.txt
# dir

# kubectl delete -f ./yaml/windowsmany.yaml