# OpenFaaS deployment on DevNet Sandbox K8s

echo "Installing OpenFaaS CLI program"
curl -sSL https://cli.openfaas.com | sudo sh

echo "Installing Helm, package manager for k8s"
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh \
chmod +x get_helm.sh \
./get_helm.sh

echo "Create RBAC permissions for Tiller"
kubectl -n kube-system create sa tiller \
 && kubectl create clusterrolebinding tiller \
  --clusterrole cluster-admin \
  --serviceaccount=kube-system:tiller

git clone https://github.com/openfaas/faas-netes

cd faas-netes

echo "Initiating helm"
helm init --skip-refresh --upgrade --service-account tiller

echo "Installing OpenFaaS using the OpenFaaS Helm Chart"
helm upgrade --install --debug --reset-values --set async=true openfaas openfaas

echo "Installing sample functions for OpenFaaS"
faas-cli deploy -f https://raw.githubusercontent.com/openfaas/faas-cli/master/samples.yml --gateway http://127.0.0.1:31112
