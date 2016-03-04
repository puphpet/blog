---
title: Multi-Machine Support Added
categories:
    - new-features

---

tl;dr: You can spin up multiple machines with a single `vagrant up`. Unfortunately,
old configs are no longer drag/drop compatible!

-------------

Since its creation, PuPHPet has had a well-defined purpose: Provide an interface
for developers to quickly and easily configure, launch and distribute highly
customized virtual machines.

The project has more than its fair share of bugs. In fact, it has the unenviable
position of having to react to upstream changes in outside dependencies that constantly
break existing, working configs. That said, I do believe that so far it has accomplished
its goal quite well!

## One "vagrant up", Limitless Machines

One thing that has constantly remained on my wishlist feature-wise has been the ability
to spin up multiple machines with a single `vagrant up` command.

Until very recently, PuPHPet has generated a config for a single machine. If you wanted
to create another identical machine, you would need to copy the whole unzipped directory,
delete the `.vagrant` directory if it existed within, and then run `vagrant up` in the
new directory. Not many steps, really, but now you have identical directories for
identical machines, with double the number of Puppet module files littering your hard
drive.

Now, however, you can define multiple machines in a single config file!

For some time you have been able to install Nginx or Apache and add as many virtualhosts
as you'd like. I took the same concept and applied it to defining as many machines as
you'd like.

Thankfully,
[Vagrant has had native support for multiple machines for some time now](https://www.vagrantup.com/docs/multi-machine/).

With this recent update, you can create identical machines that you can deploy to any
provider you would like, including locally, Rackspace, Digital Ocean, AWS, etc.

Unfortunately, due to limitations of Vagrant, I was unable to provide the feature of
choosing different provider from a single config. For example, you cannot currently spin
up one machine on AWS, another on Rackspace, and another on Linode. All machines must
be deployed to the same provider. *[0]*

## One Provider, Multiple Datacenters

You are limited to a single provider, yes, *but* if the provider offers multiple
datacenters you are free to deploy to as many datacenters as your wallet allows.

Take Digital Ocean, for example. You can currently deploy to the following datacenters:

New York 1, New York 2, New York 3, San Francisco 1, Amsterdam 1, Amsterdam 2,
Amsterdam 3, Singapore 1, London 1, Frankfurt 1

Now you can create as many machines as you want, from one config, and choose to deploy
each machine to a different (or same) datacenter.

Aside from that, you can also customize memory and CPU per machine.

## Cool! So What Is This For?

Adding multiple machine support to PuPHPet introduces a *massive* benefit: All of a sudden
you easily and quickly create a highly redundant, scalable, high-availability application!

For instance, you can create one config that spins up 10 machines, spread across the globe.
These machines handle your application exclusively. Spin up another 3 machines to house
your replicated databases.

Then, you can either spin up another machine to house your static files or do it
The Right Way and use S3.

Lastly, you can install HAProxy to distribute the load between each machine, and to
handle the case when one machine stops responding.

With little effort you have created a very powerful network of machines to make your
application faster and more stable.

## The Thing About HAProxy...

HAProxy support is not currently implemented within the GUI. I have been working
on a solution to add HAProxy and have been using it privately. It works well.

However, even if you create a server that houses HAProxy, you still need to tell HAProxy
itself about the IP addresses of the machines you want it to forward traffic to. Currently,
this would need to be handled manually - you spin up your app/database servers, grab the
IP address of the machines, add those to your HAProxy config and then spin that server up.

If you add new servers you need to add those IPs to the HAProxy config and
`vagrant provision`.

This works *ok*, but no one likes to do manual tasks that can be easily automated.

One solution I've come up with is using Jenkins to spin up new machines, grab the new IP
addresses, add them to an existing HAProxy config and then provision that machine.

If I cannot figure out a more elegant way that does not require a build server, I will
eventually write a tutorial on how to set this up.

## Broken Backward Compatibility

Unfortunately with this new feature comes one small downside: configs generated before this
change are no longer fully compatible with the GUI. If you drag/drop your config.yaml file,
everything will be populated as before, except no machines will be defined.

All you need to do is simply choose your provider and add your machine(s) as usual.
That's it!

Have fun, learn something!

Juan Treminio

**[0]** Truthfully, it is rather easy to add multiple providers to multiple machines in a
single config. However, the problem is requiring to pass in the `--provider` flag via the
command line. I was not happy with the final implementation, however, and decided to
stick with one config, one provider for now.
