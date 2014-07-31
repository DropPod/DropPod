class baseline {
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
  exec { "Configure git-credential-osxkeychain":
    environment => ["HOME=/Users/${id}"],
    command     => "git config --global credential.helper osxkeychain",
    unless      => "test `git config --global credential.helper` = 'osxkeychain'",
    path        => ["/usr/local/bin", "/bin"],
    require     => Package['git'],
  }
}
