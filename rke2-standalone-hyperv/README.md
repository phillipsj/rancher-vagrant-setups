# Setup

You need to have the following installed on Windows 10 or 11.

1. Hyper-V and Tools
2. Vagrant, I recommend you install using [Chocolatey](https://community.chocolatey.org/packages/vagrant)
3. Create a local user using [lusrmgr](lusrmgr.msc)
4. The local user should be member of **Administrators**, and the **Hyper-V Administrators** group
5. Assign the user to **rancher-vagrant-setups** folder

# Running 

Vagrant requires that you are using an admin prompt, I recommend PowerShell running with Windows Terminal. There is one controlplane node called `main`, and one Linux node called `linuxworker`. You can now choose to boot just a Windows 2019 node called `winworker` or a Windows 2022 node called `winworker22`. I typically just boot a three node system like so:

```Bash
vagrant up main linuxworker winworker --provider hyperv
```

You will get a prompt for the SMB step that is required to share registration information from the RKE2 controlplane, each time you will need to enter <account@domain> for the SMB_USERNAME and then your password. You can alternatively set environment variables that it can use.

```PowerShell
$env:SMB_USERNAME="<user>"
$env:SMB_PASSWORD="<password>"
```

Once it all boots, ssh into `main` and test that your nodes are all ready. 

```Bash
vagrant ssh main
```

Now you can check your nodes with kubectl.

```Bash
$ kubectl get nodes
NAME          STATUS   ROLES                       AGE     VERSION
linuxworker   Ready    <none>                      7m14s   v1.22.4+rke2r2
main          Ready    control-plane,etcd,master   9m50s   v1.22.4+rke2r2
winworker     Ready    <none>                      71s     v1.22.4
```

## It can take 10-15 minutes

The Windows node can take sometime to come up based on the speed of your machine and the resources you provide to it. It has to boot, install the Containers feature, then restart and finish the RKE2 provisioning. Then the RKE2 registration can take a few minutes due to registration and Calico networking.




