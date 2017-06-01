# Continuous Deployemtn with Ansible and Docker

This template demonstrates how to use ansible and docker to automatically deploy a web service to a remote server from gitlab.

## The Web Service

The web service to be deployed is not included in this template. For demonstration services the configuration assumes that the service will be deployed in four parts:

* client: a website, bundled as a docker container
* server: a backend server, also bundled as a docker container
* mongo: database server based on the official docker container
* haproxy: proxy server based on the haproxy-letsencrypt docker container (includes automatic and free ssl certificate generation for your domain)

The template can be easily extended to deploy additional docker containers, like a backup script, a static website or multiple backend services, by adding new roles for each container and editing the haproxy configuration file as needed.

## Ansible

Ansible is used to install and maintain the docker containers on your servers. The folder `ansible/` holds the ansible configuration. There are two playbooks:

* `setup` sets up a new debian server
* `update` installs and updates the components of our web service

The hosts are specified in `config/inventory`. SSH keys are placed in `config/ssh`.

There are 5 roles:

* `client` installs a simple docker container with no dependencies (the client should access the backend via the proxy server)
* `common` sets up new debian box with docker (this will need some tweaking depending on your setup and distribution)
* `haproxy` installs the proxy server. The configuration file contained might need some tweaking for your setup.
* `mongo` installs the database server. It is accessible from localhost via port 27017 and can be linked to other containers. It is not accessible from external hosts.
* `server` install another docker container with a dependency to the mongo container

The script `run` is used as the entrypoint for the docker container described below.

## Docker

Docker is used to create a docker container from this repository. This docker container can be used to execute deployment tasks from a CI such as gitlab-ci.

The docker configuration is stored in `Dockerfile`. It is based on a docker container by Jens Böttcher, which is appropriate for usage with Gitlab's CI.

To build the container run `docker build -t my-ansible .`. Then you can execute a playbook by running e.g. `docker run my-ansible update`.

## Gitlab CI

`gitlab-ci.yml` contains a sample configuration to automatically build this container. It also contains two manual tasks that can be triggered to call either playbook.

`gitlab-ci.client.yml` contains a sample configuration for the client. You need to fill in how to build your client and add a Dockerfile. Then the client is containerized and pushed to the gitlab registry. Finally, the deploy step will use the ansible container from this repository to deploy the client on your server.


# License

Copyright (c) 2017 Jonathan Diehl

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
