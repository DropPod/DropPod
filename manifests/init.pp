class baseline {
  include baseline::types

  # Set up the common dotfiles for every user account in the system.
  baseline::rcfiles { $id: group => 'staff' }

  # Since DropPod relies heavily on Git, there's no sense in us preferring to
  # use whatever stale version ships with XCode.
  package { 'git':
    ensure   => installed,
    provider => 'homebrew',
  }

  # Given the platform we're on, there's no reason we shouldn't configure the
  # osxkeychain credential helper by default.
  gitconfig { 'credential.helper':
    value   => 'osxkeychain',
    require => Package['git'],
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
    notify      => Exec["Set /usr/local permissions"],
  }

  # The `drop` command is the user's primary interaction with DropPod; we
  # should ensure that it's properly seated in the $PATH.
  file { "/usr/local/bin/drop":
    ensure => 'link',
    target => "/usr/local/DropPod/modules/baseline/files/drop",
    notify => Exec["Set /usr/local permissions"],
  }

  # We need to split the permissions assertions away from the existence
  # assertion to avoid a dependency cycle.  We can't use the File resource type
  # to manage permissions because that would create a dependency cycle, which
  # while completely safe in this instance, is difficult for Puppet to reason
  # about well.
  $chown = "/usr/sbin/chown -R '${id}:staff' /usr/local"
  $chmod = "/bin/chmod -R 0775 /usr/local"
  exec { "Set /usr/local permissions":
    command     => "${chown} && ${chmod}",
    refreshonly => true,
  }
}
