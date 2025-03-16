## CKA Foundation Course Cluster

I threw all this together when I was going through the learning material for the Certified Kubernetes Administrator exam. Here are the steps to use this in your own Google Cloud project.

> I do not recall what permissions are necessary, or what I used. Use the least amount of privileges necessary.

1. Setup a Google Cloud project
2. Install Google Cloud CLI (gcloud)
3. Create a Service Account within that project
4. Download the JSON credentials for that Service Account
5. Update `main.tf` to point to the JSON credentials file and your project, region, etc.
6. Run `terraform plan` and verify the output
7. Run `terraform apply`

This should apply all the resources in `main.tf` which will bring up the majority of the infrastructure. Given the nuance of the labs being specific to the Linux Foundation training, here's what to do next:

1. Connect to each control plane via SSH (I believe I had to run everything on each control plane node, but I could be wrong)
2. Follow the steps outlined in `control-plane-kubeadm-init.txt`

The initial deployment will have installed all the necessary tools for running and interacting with Kubernetes. What needs to be done is:

1. Update `kubeadm` version
2. Run `kubeadm init`
3. Join everything together following instructions from output (this can be automated, probably)
4. Deploying Cilium for networking

After all that, the cluster should be functional, ready for the labs if you're also doing the CKA foundational course.
