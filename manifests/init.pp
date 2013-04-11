# libffi 3.0.12
# There are issues with 3.0.13, so we're rolling back to the last version
#
#  include libffi
class libffi {
  include boxen::config

  $libffi_path = "${boxen::config::home}/libffi"
  $libffi_version = 'v3.0.12'
  #$libffi_patch = "patch -Np1 -i 3.0.13.patch"

  repository { 'libffi repo':
    source   => 'atgreen/libffi',
    provider => 'git',
    path     => $libffi_path,
  }

  exec { 'checkout libffi':
    command => "git fetch origin && git reset --hard && git checkout -b '${libffi_version}' '${libffi_version}'",
    cwd     => $libffi_path,
    before  => Exec['install libffi'],
    unless  => "git branch | grep -c '* ${libffi_version}'",
  }

  exec { 'install libffi':
    command  => "${libffi_path}/configure --prefix=${libffi_path} --disable-static --enable-debug && make && make check && make install && echo ${libffi_version} > ${libffi_path}/.version",
    unless   => "grep -c ${libffi_version} ${libffi_path}/.version",
    before   => Exec['add installed libffi files to git repo'],
  }

  exec {'add installed libffi files to git repo':
    command => 'git add .',
    cwd     => $libffi_path,
    before  => Exec['install glib']
  }

}