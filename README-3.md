## Challenge #3

### Deploy a webapp using Terraform and Kubernetes

- Simulate varying levels of traffic / usage
- Use terraform to provision k8s clusters and dynamically scale with load
- Find the best resource configuration for 100k daily users, optimizing for cost


Here's a summary of the progress I made towards this challenge:

Keep in mind, I'm starting from basically no starting devops knowledge. only a basic background knowlege of Docker.
So in order to even start towards the goal, i needed to ramp up on some incredibly complex technologies.
I started with a deep dive on kubernetes from the ground up bare metal fundamentals to managed cluster solutions from cloud providers.
Then I learned to define infrastructure as code using terraform and DigitalOcean cli tools.

Instead of coming up with a bespoke dummy app to test around, I used someone elses project as the webapp in the cluster intending to replace it later (Serge - a llama.cpp chatbot ui).
The current version of the repo is using handwritten manifests but I also wrote and uploaded a Helm chart for Serge to use here (just didnt get around to updating these).

The tf files as they are define a managed kubernetes cluster on digitalocean with:
- basic firewall rules
- cert manager for automated TLS certificate management
- haproxy ingress controller for managing app ingresses
- access to digitalocean's S3 buckets as storage class for dynamic volume provisioning

That's about where progress had stalled due to a combination of hardware failure and real life events.

As for what remains here are my thoughts of how to get across the finish line:
- Flesh out a NextJS app to be more representitive of the types of load I'm trying to simulate
- Create a grafana dashboard hooked up to the app with some metrics like latency and time to load, etc
- Design a K6 test suite for load testing/stress testing in order to test autoscaling
- Tune and optimize vertical/horizontal pod autoscaling for cost @ ~100k user/day
