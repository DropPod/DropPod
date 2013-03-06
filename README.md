Drop Pod
========

### Precision workstation deployments falling out of the clouds. ###

#### It's launch day. ####

Your new machine arrives as a blank slate, ready for you customize and love.
Between installing all your favorite applications, setting up all your
shortcuts, and getting all the dependencies for your projects configured,
you're looking at a week's work – all to get back to where you left off with
your *last* computer.

#### Skip the housekeeping and get back to work. ####

**Drop Pod** provides you with a platform for quickly bootstrapping new OS X
workstations for software developers. Think of it like [Bundler][Bundler] for
your machine's setup. From installing applications to configuring your System
Preferences, your new machine will get the same configuration you left behind
(in a fraction of the time).

Getting Started
===============

If you've never used Drop Pod before and want to build your configuration from
scratch, you can start with a "Beachhead" install:

``` shell
# Install Xcode CLT from https://connect.apple.com
$ bash -c "$(curl -fsSL https://raw.github.com/DropPod/DropPod/launch)"
```

This script pulls down a minimal **Drop Pod** installation, ready for you to
advance.

If you've already got a configuration file (or you want to use someone else's
as as starting point), you can launch a "Spearhead" install:

``` shell
# Install Xcode CLT from https://connect.apple.com
$ bash -c "$(curl -fsSL https://raw.github.com/DropPod/DropPod/launch)" -- https://gist.github.com/pvande/5035792/raw/apps.pp
```

Once you've got a basic installation, you've got [Git][Git],
[Homebrew][Homebrew], and (of course) your compiler toolchain. Now it's time to
occupy your machine. If you're going to be comfortable in your own computer,
you're going to want to set it up the way you like it. **Drop Pod** uses a
declarative configuration language (care of [Puppet][Puppet]) to create "pods"
– discretely compartmentalized configuration files describing your desired
workstation setup. Pods may range in size from managing the creation of a
single file or symlink, through managing the full set of applications you use,
setting up the projects you work on, and configuring your OS preferences to
match your exacting standards. This composable modularity allows you a high
degree of freedom in your setup.

At its most basic level, the configuration language follows this pattern:

```
<type> { "<name>": (<parameter> => <value>,)* }
```

As an example, consider the `application` type, which installs applications
from the Internet. To install Google Chrome, you'd write something like this:

``` puppet
application { "Google Chrome.app":
  source => "https://dl.google.com/chrome/mac/stable/GoogleChrome.dmg"
}
```

With your configuration orders in hand, deploying the changes to your system is
a simple matter of running:

``` shell
$ drop pod <filename>
```

That filename may be an accessible URL, or may be omitted entirely, which will
automatically deploy the configuration file in `~/.pod.pp`. ([Like
Homebrew][no-sudo], you never need to run `drop` with `sudo`.)

With these tools in hand, configuring your machine is a matter of learning the
types you have at your disposal.

Types
=====

#### application ####

This type installs downloaded applications, whether from DMGs, ZIP archives, or
tarballs.

* *name* : A unique name identifying the application.
* *source* : The URL from which the application can be downloaded.
* *ensure* : The desired state for the application.  Accepted values are
             `installed` (the default) and `latest`.

#### rcfile ####

This type adds new shell configuration files, to be automatically loaded on the
next terminal creation.

* *name* - A unique name for the configuration file; ideally named after the
           configured behaviors.
* *content* - The configuration file's content; if absent, defers to `source`
* *source* - Indicates that the the configuration file should be copied from
             the specified location; if absent, defers to `content`.

Future
======

We're just getting this wild ride started. We know that we're still a long way
from world domination, but we're scratching our own itches right now, and
hopefully some of yours. Filing issues is the quickest way to let us know what
functionality is valuable to all you out there in the real-world, and we're
more than happy to accept patches that fix bugs, implement useful shortcuts,
and generally improve the tool for everyone.

[Bundler]: http://gembundler.com/
[Git]: http://git-scm.com/
[Homebrew]: http://mxcl.github.com/homebrew
[Puppet]: https://puppetlabs.com
[no-sudo]: https://github.com/mxcl/homebrew/wiki/FAQ#wiki-sudo
