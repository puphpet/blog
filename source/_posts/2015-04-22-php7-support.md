---
title: PHP7 Support Added
categories:
    - new-features

---

[Nightly builds of PHP7 were recently added to PuPHPet](https://puphpet.com/#php).

tl;dr: PHP7 now available for testing, but only for Ubuntu 14.04 x64 boxes.

The builds are taken from [Zend PHP7 Nightly Builds page](http://php7.zend.com/) and hosted on PuPHPet's servers.

Ubuntu 14.04 x64 was easy enough to add support for.

RHEL seems to mean true RHEL, as I had problems attempting to get it running on CentOS 6.7 (`libgmp.so.10` was not in any of the repos I use).

Debian 7.7 Wheezy also ran into problems, with outdated libraries. The libraries are in Jessie, but it seems that updating them would upgrade most of the system, basically turning the system into Jessie.

## Caveats

`PEAR`, `PECL` and `apt`/`yum` modules are obviously not working yet.

Thankfully the package comes with several modules already pre-baked in.

Derick Rethans is still working on getting `Xdebug` to work with PHP7, so you can't debug this yet.

Many third-party libraries that require PHP module be installed will problably not work. For example, [MongoDB does not yet work with PHP7](http://docs.mongodb.org/ecosystem/drivers/php/#language-compatibility).

MySQL, however, is one of the baked-in modules and seems to work fine.

## Final Thoughts

I believe that CentOS 7 will work with the RHEL version. However, each box requires generated for 3 different provisioners (Virtualbox, VMWare, Parallels) and takes several hours of babysitting to make sure everything goes smoothly. Then you have to consider that I would need to test all other packages available on PuPHPet.com to make sure everything is working well and the required time investment to getting CentOS 7 working rockets.

Debian Jessie is not out yet and I do not want to spend time on a non-stable distro just yet.

If you're simply looking to start working with PHP 7 in a hassle-free manner then I believe the Ubuntu distro will suffice. You can even deploy it to a public server using any of the Deploy Target options available on PuPHPet.

PHP internals would also love for you to test out each nightly build and [begin reporting any and all bugs](https://bugs.php.net/index.php) you may run across.

Have fun, learn something!

Juan Treminio
