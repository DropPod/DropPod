define baseline::rcfiles($user=$name, $group) {
  file {
    "/Users/${user}/.profile":
      ensure => present,
      mode   => 700,
      owner  => $user,
      group  => $group,
      source => 'puppet:///modules/baseline/.profile';
    "/Users/${user}/.profile.d":
      ensure  => directory,
      recurse => true,
      purge   => false,
      mode    => 700,
      owner   => $user,
      group   => $group,
      source  => 'puppet:///modules/baseline/.profile.d';
  }
}
