GITHUB_URL=https://github.com/kubernetes/dashboard/releases
VERSION_KUBE_DASHBOARD=$(curl -w '%{url_effective}' -I -L -s -S ${GITHUB_URL}/latest -o /dev/null | sed -e 's|.*/||')
echo $GITHIUB_URL
echo $VERSION_KUBE_DASHBOARD
kubectl create namespace dashboard
kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/${VERSION_KUBE_DASHBOARD}/aio/deploy/recommended.yaml --namespace=kubernetes-dashboard
kubectl apply -f dashboard.admin-user.yaml --namespace kubernetes-dashboard
sleep 5
kubectl -n kubernetes-dashboard describe secret admin-user-token | grep ^token
kubectl -n kube-system -n kubernetes-dashboard get service kubernetes-dashboard -o yaml > kube-dash-svc.yaml
sed -i 's/ClusterIP/NodePort/' kube-dash-svc.yaml
sed -i '/clusterIP/d' kube-dash-svc.yaml 
kubectl -n kubernetes-dashboard delete svc kubernetes-dashboard
kubectl -n kubernetes-dashboard create -f kube-dash-svc.yaml

