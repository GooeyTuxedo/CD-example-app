## Challenge #2

### Expose a public IPFS gateway

- Use HAProxy to route traffic between a web app and remote ipfs gateway node
- Web app is served at domain root
- Ipfs gateway accessible at `ipfs` subdomain 

------------------

### Scope creep

- The ipfs gateway I'm running from home is an [ipfs-cluster](https://ipfscluster.io) docker container set x3 with a shared pinset and haproxy load balancing between them
- Every component is running in a docker container:
    - web app
    - certbot with auto renewal script
    - haproxy
    - ipfs nodes
    - ipfs-cluster controllers
- Opened an authenticated https api for pinning objects to the ipfs cluster

