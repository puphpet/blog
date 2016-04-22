---
title: Let's Encrypt Support Added
categories:
    - new-features
    - information

---

tl;dr: Support for automated Let's Encrypt SSL certificates has been added to
both Nginx and Apache webservers.

---

You are now able to spin up a server with Nginx or Apache and choose to generate
your valid (and free!) SSL certificates using Let's Encrypt. The certs are
automatically renewed once a month.

## What is Let's Encrypt?

[Let's Encrypt](https://letsencrypt.org/) is a new SSL certificate provider
taking the industry by storm.

It used to be that you would need to pay at least $10/year for a single-domain
certificate. Some registrars like Namecheap would provide a free certificate
for your domain's first year, but would require you purchase a certificate
once the free one expired.

Thanks to Let's Encrypt you are now able to create SSL certificates that are
accepted by all major web browsers. Best of all, they are completely free.

However, there are some caveats to keep in mind:

### The certificates are only valid for 90 days.

Usually certificates from your traditional vendors will last at least one year.

With Let's Encrypt you *must* renew your certificate at least once every 90 days.
If you do not renew before 90 days, your certificate will expire and will no
longer be valid.

This is actually a *good* decision, as it forces developers to implement
auto-renewal into their devops workflow. Every one of us has scrambled a year
after purchasing our certificate because we simply forgot to keep track and oops!
it's expired now.

### No wildcard certificates available

Many registrars offer wildcard certificates for purchase. This means instead of
purchasing one certificate for each of `sub1.bar.com`, `sub2.bar.com` and
`sub3.bar.com`, you can purchase a single certificate that is valid for `*.bar.com`.

Let's Encrypt does not currently offer this, and probably never will. For each
unique domain and subdomain you wish to protect you must request a new
certificate. Thankfully this is a painless, streamlined process, as long as
you stay within their rate limits.

### No extended validation

Let's Encrypt does not currently offer the cute green bar visible and
[PayPal](https://paypal.com) or your bank.

This type of certificate requires the vendor to manually verify your information
and cannot be completely automated.

If you are dealing with data that requires extended validation certificates you
are still required to use one of the traditional vendors.

### Rate limits

Let's Encrypt enforces fairly generous rate limits.
[You can view full details here](https://community.letsencrypt.org/t/rate-limits-for-lets-encrypt/6769)
but the tl;dr of it is:

* 20 certificate issuances per domain per 7 days,
* 5 certificates per unique set of FQDNs per 7 days,
* 500 registrations per IP per 3 hours,
* 300 pending authorizations per account per week, and
* 100 subject alternative names per certificate

If you have a fairly small amount of domains and subdomains you should fall well
within the rate limits. If you have a large pool of domains you need certificates
for then you may run into the rate limit.

As of right now the only solution is to simply move the domains over in small
chunks as the rate limit clears for you.

## Challenges Integrating into PuPHPet

Adding Let's Encrypt into the existing PuPHPet workflow posed some challenges
that I had not anticipated.

I will assume that the most common scenario will be users creating completely
new manifests for new servers.

### Pointing DNS so domain name resolves

Let's Encrypt requires that the domain you are creating a certificate for be
publicly accessible. This means you cannot create a certificate for a
development environment (`http://puphpet.local`), or for a non-resolving domain.

If you are deploying to any host like Rackspace or Digital Ocean, you should
already have updated your nameservers to point to the proper place. Newly
registered domains may take several hours to be visible to the internet.

However, once your nameservers are updated you still need to tell your host on
*which* server the domain will reside on. This means that before spinning up
your new server, your host must have an `A Record` already in place for your
domain, *and* this record must point to the correct IP address.

How do you know your new server's IP address before spinning it up? You don't!.

There are two possible solutions to this problem:

#### Update the `A Record` after your server spins up

This means the initial attempt **will fail**. Let's Encrypt will not be able
to connect to your domain to verify your ownership of it and will refuse to
provide a certificate. This will cause ` vagrant up` to fail.

Once the server is up and has an IP address, you can then update the `A Record`
to point to the new server and run `vagrant provision`.

#### Floating IP address

Your host may provide a feature called floating IP address. Simply put, it is an
publicly-available IP address that belongs to you that you can assign to any
server within your infrastructure.

If you create a floating IP and set your `A Record` to point to it then you
can actually assign the IP address to the new server right after it is
created and visible in your host's dashboard.

There is usually a 2 to 3 minute gap between when the server is available to
have a floating IP assigned to it, and when the Let's Encrypt Puppet module is
run and the domain needs to resolve to the server, so you have a nice cushion
to be able to set things up in time!

### Nginx/Apache vhosts pointing to certificate before they are generated

The recommended way to run Let's Encrypt is to use its included Apache plugin
and to install the Nginx plugin. They handle everything that needs done by
creating temporary vhost configs and removing them once the cert is generated.

Unfortunately the way Puppet works, the certs must be created by the time the
Nginx and Apache vhosts are setup, pointing to where it expects the certs to
be located.

On initial `vagrant up`, the certs will not be generated in time, failing the
build.

The solution is to use the Let's Encrypt included standalone server option to
listen on port 80 and generate the certs.

### Webserver integration/port conflicts

Needing to run Let's Encrypt using its standalone server option means that it
must run and generate certs before Nginx or Apache are even running because
they lock down port 80.

Attempting to run the process after Nginx or Apache are installed, but before
vhosts are configured, will fail because port 80 is already in use and Let's
Encrypt cannot listen in on it.

On subsequent cert renewals Let's Encrypt creates a temporary directory within
your target vhost webroots to verify domain ownership, and removes this directory
once the certificate has been renewed and downloaded. Neither Nginx or Apache
need to be turned off during the renewal process, and with luck you will never
realize it renewed unless you check the certificate issued date!

---

Let's Encrypt offering free certificates that require constant renewal ushers
in a new era for encrypting everything by default.

Once you remove the cost and force a machine to handle the process for you then
enforcing SSL encryption for all your public websites is no longer a hassle, but
simply something you do for a new domain, as simple as choosing to install
Nginx or PHP.

There are many more articles that go into more detail on Let's Encrypt that I
could possibly write about. I encourage you to learn more about this awesome
new service and show your support by using them to create your next SSL
certificates!

Have fun, learn something!

Juan Treminio
