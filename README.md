# Consul Service Mesh with Serverless

This is an example of Consul Service Mesh with serverless.
In this case, we use:

- OpenFaaS
- Nomad
- Consul

to quickly demonstrate how service networking can facilitate
security and management of serverless.

## Premise

We wrote a function that:

- Accesses a database containing 311 complaints submitted to New York City on
  Halloween 2018.

- Aggregates the data for a given borough and returns the total number of
  complaints for the borough.

However, we find out that a compliance requirement outlines that production
infrastructure must only connect to production data.

## Solutions

We can meet this compliance requirment with a few solutions:

1. Firewall (selectively whitelist IP address)
1. Network segmentation (by allowing access within whole subnet)
1. API Authorization (tokens)
1. Intent-based networking, using service mesh

![Production and development databases, with firewall, network, API, and
intent-based networking solutions.](images/solution.png)

Let's examine intent-based networking to prevent a non-production function from
access production data!

## Demo

### Pre-Requisites

- Vagrant. The demo requires a Linux machine so CNI plugins work for Nomad.

### Instructions

1. Start up a Vagrant box with all of the dependencies installed. `vagrant up`
1. Open Consul UI. `open http://192.168.50.5:8500`
1. Open Nomad UI. `open http://192.168.50.5:4646`
1. Get into the Vagrant box. `vagrant ssh`
1. Deploy the databases and the functions.
   ```shell
   cd serverless-consul
   nomad run nomad_job_files/dev-db.hcl
   nomad run nomad_job_files/prod-db.hcl
   nomad nomad_job_files/prod-db.hcl
   ```
1. You should see the function and the two databases in Consul and Nomad.
1. The function will access the development database by default. Run
   `curl 10.0.2.15:8080/function/nyc311-halloween-prod -d 'Manhattan'` will
   yield the number of complaints in Manhattan.
1. This is not allowed! Let's deny the traffic from production function to
   development database by adding an intention.

### Clean-Up
```shell
vagrant destroy --force
```