# https://github.com/clastix/capsule/blob/master/charts/capsule/README.md

kubectl apply -f https://raw.githubusercontent.com/clastix/capsule/master/config/install.yaml

kubectl apply -f ./yaml/capsule_v1beta1_tenant.yaml

kubectl get tenants

./hack/create-user.sh bob gas # run at linux node