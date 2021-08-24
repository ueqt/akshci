# 测TPS：Jmeter，https://jmeter.apache.org/download_jmeter.cgi，要装JDK

# http://servicecomb.apache.org/cn/docs/stress-test-on-company-with-jmeter-in-k8s/
# https://blog.csdn.net/yaorongke/article/details/82827718

kubectl apply -f ./yaml/tps-nginx.yaml

# kubectl delete -f ./yaml/tps-nginx.yaml

https://www.cnblogs.com/yoyoketang/p/14181902.html