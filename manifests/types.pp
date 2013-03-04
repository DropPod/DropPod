# Create a nice little hook for the autoloader.
class baseline::types {}

# A basic application type as a shorthand for the 'dotapp' provider.
#
# * name - The name of the application to install from the package
# * source - The URL or path where the application can be found
# * [ensure] - Conditional upgrade flag; valid values are `installed` (default)
#              and `latest`
#
#    application { 'Google Chrome.app':
#      source => 'https://dl.google.com/chrome/mac/stable/GoogleChrome.dmg',
#    }
define application($source, $ensure="installed") {
  package { $name:
    ensure   => $ensure,
    provider => 'dotapp',
    source   => $source,
  }
}

# A type for introducing new shell configurations.
#
# * name - A unique name for the configuration file; ideally named after the
#          configured behaviors
# * [content] - The configuration file's contents; if absent, defers to `source`
# * [source] - Indicates that the the configuration file should be copied from
#              the specified location; if absent, defers to `content`
#
#    rcfile { 'prompt':
#      content => 'export PROMPT="[%n@%m:%c]%#"',
#    }
define rcfile($content=undef, $source=undef) {
  file { "/Users/${id}/.profile.d/${name}.sh":
    ensure  => present,
    mode    => 644,
    owner   => $id,
    content => $content,
    source  => $source,
  }
}
