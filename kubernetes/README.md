#Kubernetes:

QUICK STEPS:
```
# cd terraform_cthunder/

# ls 

    acos_docker_5_2_0_155.tar.gz, bridge.yaml, config.tf, deployment_kube.tf

# cp /etc/kubernetes/admin.conf ./

# Edit 

# docker load -i acos_docker_5_2_0_155.tar.gz

# docker images

    acos_docker_5_2_0_155                 latest              13d85c17a02e        5 days ago          2.82 GB

# Edit deployment_kube.tf 

    resource>spec>template>spec>container>image = “acos_docker_5_2_0_155:latest”

# kubectl create -f bridge.yaml --namespace acos

# kubectl describe -f bridge.yaml --namespace acos

# Edit deployment_kube.tf 

    resource>spec>template>metadata>annotations = 

{

"k8s.v1.cni.cncf.io/networks" = "server-bridge"

}

# Edit deployment_kube.tf to support “acos” Namespace

    resource>metadata>namespace = “acos”

# terraform init

# terraform plan

# terraform apply --auto-approve

# kubectl get pods -o wide

    cthunder-6cf77c94b8-wl52m           1/1     Running     0          59m     99.99.99.99

# terraform destroy
```
