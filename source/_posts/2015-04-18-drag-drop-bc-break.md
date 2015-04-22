---
title: Drag & drop BC breaking changes
categories:
    - information

---
Due to recent changes to many modules that PuPHPet offers, `config.yaml` files generated before 04/18/2015 will no
longer 100% match the GUI.

Changes include but are not limited to the following:

## Deploy Target

Previously, whenever you generated a new config, the target section would be named as `vagrantfile-${target}`.
For example, `vagrantfile-local`, `vagrantfile-rackspace`, `vagrantfile-digitalocean`, etc.

This has been changed to a single key, `vagrantfile`. Now when you choose a deploy target in the GUI the proper values
will be chosen and everything else hidden.

Meaning if you choose local then values specific to local will be added to your `config.yaml` file, and everything else
omitted. Likewise, if you choose Rackspace then the proper API fields will be added and local and other target values
omitted.

Making this change makes the `config.yaml`, `Vagrantfile` and GUI easier to read and maintain as there no longer
requires switching to decide which target is being chosen.

This also has the side effect of preventing issues like [puphpet#1258](https://github.com/puphpet/puphpet/issues/1258),
a bug where multiple providers would end up in a single config file.

## Apache/Nginx

Both Apache and Nginx were heavily refactored.

Nginx support has always been iffy, but with the recent changes everything is working quite well. I implemented proper
`Location` and `FastCGI` support. Everything used to be semi-hardcoded but is now completely configurable by the user.
I also change the default webserver from Apache to Nginx as I got more familiar and comfortable with it.

For Apache, I completely dropped support for version 2.2.x, and also dropped support for `mod_php`. Everything is 100%
fcgi using `php-fpm`.

I also learned about Apache's `FilesMatch` directive, which was introduced in version 2.4.10. In-depth support for
`Directory` and `FilesMatch` is now the name of the game.

## MySQL/PostgreSQL/etc

The databases' forms were also refactored to completely split up the user, database and permissions fields. This allows
for far more granular control.
