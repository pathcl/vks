
NOTE: Work In Progress

# Virtual Kubelet for systemd

This is an virtual kubelet provider that interacts with systemd. The aim is to make this to work
with K3S and go from there.

`vks` will start pods as plain processes, there are no cgroups (yet, maybe systemd will allow for
this easily), but generally there is no isolation. You basically use the k8s control plane to start
linux processes. There is also no address space allocated to the PODs specically, you are using the
host's networking.

"Images" are referencing (Debian) packages, these will be apt-get installed. Discoverying that an
installed package is no longer used is hard, so this will not be done.

## Questions

* Pods can contain multiple containers. In systemd each container is a Unit (file). How can we keep
  track of these diff. Units and re-create the Pod when we need to?
* Pod storage, secret etc. Just something on disk? `/var/lib/<something>`?
* How to provision a Debian system to be able to join a k3s cluster? Something very minimal is
  needed here. _Maybe_ getting to k3s super early will help. We can then install extra things to
  configure?
* Add a private repo for debian packages. I.e. I want to install latest CoreDNS which isn't in
  Debian. I need to add a repo for this... How?

## Use with K3S

Download k3s from it's releases on GitHub, you just need the `k3s` binary. Use the `k3s/k3s` shell
script to start it - this assumes `k3s` sits in "~/tmp/k3s". The script basically starts k3s with
basically _everything_ disabled.

Compile cmd/virtual-kubelet and start it with:

~~~
./cmd/virtual-kubelet/virtual-kubelet --kubeconfig ~/.rancher/k3s/server/cred/admin.kubeconfig \
--enable-node-lease --disable-taint
~~~

Now a `k3s kubcetl get nodes` should show the virtual kubelet as a node:
~~~
NAME    STATUS   ROLES   AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE            KERNEL-VERSION     CONTAINER-RUNTIME
draak   Ready    agent   6s    v1.18.4   <none>        <none>        Ubuntu 20.04.1 LT   5.4.0-53-generic   systemd 245 (245.4-4ubuntu3.3)
~~~

`draak` is my machine's name.

THIS IS AS FAR AS I AM RIGHT NOW.

- Scheduling a pod doesn't seem to connect to my virtual kubelet
- For some reason the node is *Ready*, but scheduling pods fail because of storage(??). Seeing
  things like
   ~~~
   W1115 14:51:24.961835   58734 actual_state_of_world.go:506] Failed to update statusUpdateNeeded field in actual state of world: Failed to set statusUpdateNeeded to needed true, because nodeName="draak" does not exist
   I1115 14:20:11.926828   54046 util.go:222] Skipping processing of pod "default"/"openssh-server": it is scheduled to node "draak" which is not managed by the controller.
    I1115 14:20:11.926952   54046 attach_detach_controller.go:440] Skipping volume "default-token-zjhfs" for pod "default"/"openssh-server": it does not implement attacher interface. err=no volume plugin matched
   ~~~~
