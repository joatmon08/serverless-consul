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

Let's examine intent-based networking to prevent a non-production function from
access production data!

## Demo

1. Start up a Vagrant box with all of the dependencies installed. `vagrant up`
1. Open Consul UI. `open http://192.168.50.5:8500`
1. Open Nomad UI. `open http://192.168.50.5:4646`
