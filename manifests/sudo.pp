class baseline::sudo {
  # Set up the common dotfiles for every new user account in the system created
  # after we've installed DropPod.  No reason they should be left behind.
  baseline::rcfiles { "User Template":
    user  => "root",
    group => "wheel",
    path  => "/System/Library/User Template/English.lproj",
  }

  # Ensure that the /usr/local and /usr/local/bin directories exists.
  file { "/usr/local":
    ensure => directory,
    notify => Exec["Set /usr/local permissions"],
  }
  file { "/usr/local/bin":
    ensure => directory,
    notify => Exec["Set /usr/local permissions"],
  }

  # The `drop` command is the user's primary interaction with DropPod; we
  # should ensure that it's properly seated in the $PATH.
  file { "/usr/local/bin/drop":
    ensure => present,
    mode   => 0775,
    source => "puppet:///modules/baseline/drop",
    notify => Exec["Set /usr/local permissions"],
  }

  $init   = "git init -q"
  $test   = "(git remote -v | grep origin | grep 'https://github.com/mxcl/homebrew (fetch)')"
  $remote = "(${test} || git remote add origin https://github.com/mxcl/homebrew)"
  $fetch  = "git fetch origin master:refs/remotes/origin/master -n --depth=1"
  $reset  = "git reset --hard origin/master"
  exec { "Install Homebrew":
    environment => ["GIT_DIR=/usr/local/.git", "GIT_WORK_TREE=/usr/local"],
    command     => "${init} && ${remote} && ${fetch} && ${reset}",
    creates     => "/usr/local/bin/brew",
    group       => "staff",
    path        => ["/usr/local/bin", "/usr/bin"],
    require     => File["/usr/local"],
    notify      => Exec["Set /usr/local permissions"],
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