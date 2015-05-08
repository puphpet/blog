---
title: Better SSL Security
categories:
    - new-features

---

[PuPHPet recently changed the default openssl ciphers and protocols for https vhosts](https://github.com/puphpet/puphpet/commit/142439552679c7937e1f669052cee0b7c6f57709).

I recently had to renew the domain registration for PuPHPet.com, as well as the SSL certificate issued by COMODO.

I won't go into how [maddeningly easy it is to mess up your certs](https://twitter.com/juantreminio/status/596557761967697921),
but after uploading them to the server and restarting Nginx, I ran several SSL tests against the domain
[[0]](https://sslcheck.globalsign.com/en_US/sslcheck/?host=puphpet.com)
[[1]](https://www.ssllabs.com/ssltest/analyze.html?d=puphpet.com&hideResults=on&latest)
[[2]](https://www.sslshopper.com/ssl-checker.html?hostname=puphpet.com) and noticed that the scores were B's or C's.

Apparently the server was getting dinged for supporting SSL 3.0 protocol, which has had some [problems recently in the
form of the so-called POODLE Attack](https://www.us-cert.gov/ncas/alerts/TA14-290A).

After spending several hours reading up on SSL certs, and using
[Mozilla's SSL Configuration Generator](https://mozilla.github.io/server-side-tls/ssl-config-generator/)
I ended up with what you see in the commit link above.

After re-running the SSL testers, all scores came back as A's.

SSL 3.0 support is removed by default, and Mozilla's recommended ciphers have been set by default for all SSL-enabled
virtual hosts on both Apache and Nginx.

The fields are not visible in the PuPHPet GUI. This is the case for several other features as well. The reasoning
behind this decision is that somethings are best left as a default value to prevent users from accidentally creating
bad servers. However, if you really want to change the values, you can find them inside all newly generated
`config.yaml` files. Drag/dropping them into the GUI will also keep the chosen values.

With these changes, and the previously existing PuPHPet GUI, adding SSL to your website has absolutely never been
easier, and for only $10/year for the basic COMODO cert, there's really not much of an excuse not to have one for
all your sites!

Some registrars even provide a basic cert for the first year with the purchase of a domain.
[Namecheap charges $1.99](https://www.namecheap.com/domains/registration.aspx).

Have fun learning something today!

Juan Treminio
