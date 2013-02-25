class baseline {
  # Set up the common dotfiles for every user account in the system.
  $users = split($user_accounts, ':')
  baseline::rcfiles { $users: group => 'staff' }

  # Install a fresher SSL CA bundle.  Tools that would otherwise use the system
  # CA bundle and fail (like Ruby's `open-uri`) can now properly verify a much
  # broader range of SSL certificates.
  package { 'curl-ca-bundle':
    ensure   => installed,
    provider => 'homebrew',
  }

  # Since DropPod relies heavily on Git, there's no sense in us preferring to
  # use whatever stale version ships with XCode.
  package { 'git':
    ensure   => installed,
    provider => 'homebrew',
  }
}
