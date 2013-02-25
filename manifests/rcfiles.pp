define baseline::rcfiles($user=$name, $group, $path=undef) {
  if ($path) {
    $directory = $path
  } else {
    $directory = "/Users/${user}"
  }

  file {
    "${directory}/.profile":
      ensure => present,
      mode   => 700,
      owner  => $user,
      group  => $group,
      source => 'puppet:///modules/baseline/.profile';
    "${directory}/.profile.d":
      ensure  => directory,
      recurse => true,
      purge   => false,
      mode    => 700,
      owner   => $user,
      group   => $group,
      source  => 'puppet:///modules/baseline/.profile.d';
  }
}
