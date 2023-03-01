# CI/CD pipeline example app

### As a little exercise in the DevOps realm of things, I've been working in this repo to accomplish a deployment workflow/pipeline that looks like this:


- forward development occurs on the `dev` branch, feature branches are merged into `dev` via PR after successful test suite run and approval process
- commits to be included in a release are merged from `dev` into `staging` by permissioned repo admins
- when `staging` is ready for a version release, repo admins merge `staging` into `main` to trigger the production deployment pipeline
- conventional commits are added up to generate a version tagged release with changelog
- the production app server pulls the new git tagged version, spins down old container stack, and spins up a new stack rebuilt with new changes
- deployment success and version announced via discord webhook


As it stands, the only things missing from the above goal is the test suite, PR enforcement, and permissioned repo admin checks

-------------------

Started out with forking a random example app I found on the internet made to demo Node.js + MongoDB in a Docker container stack

Most of the work I've done can be found in `.circleci/config.yml`, though there's some other config files added inside the example app for pre-commit linting with husky.js

---------

### The digitalocean droplet associated with this app took some setup:

1. spin up an ubuntu 22.10 droplet
2. run [this setup script](https://raw.githubusercontent.com/do-community/automated-setups/master/Ubuntu-18.04/initial_server_setup.sh) to create a non-root admin user and register my ssh pubkey to the user
3. log in as non-root, install and setup Docker and Docker compose in a rootless configuration
4. make a `circleci` user and group, generate an ssh key and add the private key to circleci under "Additional SSH Keys"
5. as `circleci` clone this repo and spin up the stack with docker compose

### The CircleCI project also required some setup:

1. add this repo to CircleCI as a project
2. in "Project Settings" add a github "user" ssh key to authorized to push tagged branches and deploy
3. then add envirionment variables: 
  - $USER : circleci
  - $IP : < ip addr of the VPS >
  - $DISCORD_WEBHOOK_URL :  < for discord notifications >

-----------

### Room for improvement

- I'd like to simplify setting up the VPS down to running just one script so that VMs can be destroyed and rebuilt with little friction
- It would be really cool if I could spin up a new container stack and hot swap out the ports and volumes from old container stack to the new build BEFORE tearing down the old build for zero-downtime upgrades
- I need to replace the example app I forked with something that better represents the type of app I'll be using it with (full front end, backend, and db)