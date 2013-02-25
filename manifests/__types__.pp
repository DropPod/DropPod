define application($source, $ensure="installed") {
  package { $name:
    ensure   => $ensure,
    provider => 'dotapp',
    source   => $source,
  }
}
