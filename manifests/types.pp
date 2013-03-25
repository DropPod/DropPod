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

# A type for managing development projects.
#
# * name - The name of the project's directory
# * [source] - Indicates the repository that the project should be cloned from;
#              if absent, defaults to `title`
# * [target] - The directory the project should be cloned into; if absent,
#              defaults to `~/Projects`
#
#    project { 'DropPod':
#      source => 'https://github.com/DropPod/DropPod.git',
#    }
#
# TODO: Support alternate "environments".
define project($source = $title, $target = "/Users/${id}/Projects") {
  # TODO: Remove this logic duplicated from the repository type.
  if ($name =~ /\//) {
    $dirname = regsubst("${source}", ".*/([^.]*)([.]git)?", "\\1")
  } else {
    $dirname = $name
  }
  $directory = "${target}/${dirname}"
  
  repository { "${title}": name => $name, source => $source, target => $target }
  exec { "Configure Project '${title}'":
    command     => "/usr/local/bin/drop pod ${directory}/.development.pp",
    logoutput   => true,
    unless      => "/bin/test ! -f ${directory}/.development.pp || /usr/local/bin/drop test ${directory}/.development.pp",
    environment => [
      "HOME=/Users/${id}",
      "FACTER_PROJECT=${directory}",
      "FACTER_PROJECT_NAME=${name}",
    ],
    require     => [Repository[$title]],
  }
}
