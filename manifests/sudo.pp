class baseline::sudo {
  # Ensure that the /usr/local and /usr/local/bin directories exists.
  file { "/usr/local":
    ensure => directory,
    notify => Exec["Set /usr/local permissions"],
  }
  file { "/usr/local/bin":
    ensure => directory,
    notify => Exec["Set /usr/local permissions"],
  }

  # We need to split the permissions assertions away from the existence
  # assertion to avoid a dependency cycle.  We can't use the File resource type
  # to manage permissions because that would create a dependency cycle, which
  # while completely safe in this instance, is difficult for Puppet to reason
  # about well.
  $user  = inline_template("<%= ENV['SUDO_USER'] %>")
  $chown = "/usr/sbin/chown -R '${user}:staff' /usr/local"
  $chmod = "/bin/chmod -R 0775 /usr/local"
  exec { "Set /usr/local permissions":
    command     => "${chown} && ${chmod}",
    refreshonly => true,
  }
}
