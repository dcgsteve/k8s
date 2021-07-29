@echo off

echo Making sure old cluster is destroyed ...
minikube stop
minikube delete

echo Creating new cluster  ...
minikube start --driver virtualbox --nodes 3 --cpus 2 --memory 2G --disk-size 20G --addons=metallb --addons=dashboard --addons=metrics-server --install-addons=true --kubernetes-version=stable

echo Making sure old data disks are deleted ...
VBoxManage closemedium disk c:\k8s\datadisk1.vdi --delete
VBoxManage closemedium disk c:\k8s\datadisk2.vdi --delete
VBoxManage closemedium disk c:\k8s\datadisk3.vdi --delete

echo Creating new data disks ...
VBoxManage createmedium disk --filename c:\k8s\datadisk1.vdi --size 100000 --format VDI --variant Standard
VBoxManage createmedium disk --filename c:\k8s\datadisk2.vdi --size 100000 --format VDI --variant Standard
VBoxManage createmedium disk --filename c:\k8s\datadisk3.vdi --size 100000 --format VDI --variant Standard

echo Adding data disks to cluster ...
VBoxManage storageattach minikube --storagectl "SATA" --device 0 --port 2 --type hdd --medium c:\k8s\datadisk1.vdi
VBoxManage storageattach minikube-m02 --storagectl "SATA" --device 0 --port 2 --type hdd --medium c:\k8s\datadisk2.vdi
VBoxManage storageattach minikube-m03 --storagectl "SATA" --device 0 --port 2 --type hdd --medium c:\k8s\datadisk3.vdi


