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
