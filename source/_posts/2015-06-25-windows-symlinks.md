---
title: Symlink Support in Windows and Virtualbox
categories:
    - new-features

---

tl;dr: Setting up a VM with symlinks inside shared folders is now pretty easy!

I recently purchased a Windows machine with one of the primary goals being to increase PuPHPet's support for
Windows OS. On the roadmap is Hyper-V support, but right now I am picking low hanging fruit.

## Line Endings

The first thing I fixed was Window's pesky line endings messing up shell scripts. Bash would fall apart
when attempting to run scripts that contained `\r\n`. This usually happened when a Windows user would
edit a file using an editor that had not been configured to always use `\n`.
[A simple call to `sed` fixed this fairly quickly](https://github.com/puphpet/puphpet/issues/1738).

## Symlinks in Shared Folders

The next thing had been a thorn in my side for some time. Unfortunately, not having a Windows machine handy
forced me to keep putting this off, until now.

Some packages like Apache on CentOS attempt to create symlinks in the `/var/www` directory. Since Windows
doesn't have native support for Linux-style symlinks, this would fail and break provisioning.

The solution was not very easy to find, but
[thanks to some very helpful people](http://perrymitchell.net/article/npm-symlinks-through-vagrant-windows/)
I was finally able to get this working properly.

The first step is installing [*Polsedit - User Policies Editor*](http://www.southsoftware.com/). When you open it,
look for **Create symbolic links**.

[![Polsedit "SeCreateSymbolicLinkPrivilege"](/images/posts/2015-06-25-windows-symlinks-1.png)](/images/posts/2015-06-25-windows-symlinks-1.png)

Double click the row, click **Add User or Group...** and look for your username in the list. Closing the app will
automatically save your choices, and you'll need to reboot your machine.

You will only need to do this one time.

After rebooting, the only step you must keep in mind is to always run Vagrant via "Run as administrator".
You can accomplish this by running `cmd.exe` (or, preferably, [Cygwin](https://www.cygwin.com/)) with
administrator privileges.

That's it! [The code that runs the magic is here](https://github.com/puphpet/puphpet/issues/1737).

In short:

* Download Polsedit and add your user to the `SeCreateSymbolicLinkPrivilege` section
* Always run `cmd.exe` with "Run as administrator".

Here's some proof!

[![Symlinks working on Windows host](/images/posts/2015-06-25-windows-symlinks-2.png)](/images/posts/2015-06-25-windows-symlinks-2.png)

Have fun, learn something!

Juan Treminio
