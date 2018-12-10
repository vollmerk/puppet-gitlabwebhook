# Class: gitlabr10khook::install
# vim: set softtabstop=2 ts=2 sw=2 expandtab:
# ===========================
#
# This configures the gitlab-puppet-webhook that will take
# webhook triggers from gitlab and run r10k on your puppet server
# it currently only supports the PUSH mechanism
#
# Authors
# -------
# Karl Vollmer <karl.vollmer@gmail.com>
# Copyright
# ---------
# Copyright 2016 Karl Vollmer
class gitlabr10khook::install inherits gitlabr10khook {

  # We're going to need OpenSSL and various other Python packages
  # For now we're going to assume they got them all, needs to be
  # Corrected, and allow for different OS's
  ensure_packages(['python-devel','python','python-pip','gcc','git','openssl'],{'ensure'=>'present'})

  ## Checkout the Gitlab Puppet webhook
  exec { 'gitlabr10khook-checkout-from-gitlab':
    command => "git clone --branch ${gitlabr10khook::release} https://github.com/vollmerk/gitlab-puppet-webhook.git ${gitlabr10khook::install}",
    user    => 'root',
    require => Package['git'],
    creates => $gitlabr10khook::install,
    notify  => Exec['gitlabr10khook-update-python-daemon'],
  }

  ## Upgrade Python-Daemon so it works
  exec { 'gitlabr10khook-update-python-daemon':
    command     => 'pip install --upgrade python-daemon',
    user        => 'root',
    require     => Package['python-pip'],
    refreshonly => true,
    notify      => Exec['gitlabr10khook-slackweb'],
  }

  exec { 'gitlabr10khook-slackweb':
    command     => 'pip install slackweb',
    user        => 'root',
    require     => Exec['gitlabr10khook-pip'],
    refreshonly => true,
    notify      => Exec['gitlabr10khook-psutil'],
  }

  # PSutil requires gcc to compile, so we have to require that package
  exec { 'gitlabr10khook-psutil':
    command     => 'pip install psutil',
    user        => 'root',
    require     => [Exec['gitlabr10khook-pip'],Package['gcc'],Package['python-devel']],
    refreshonly => true,
  }

  ## Make sure we've checked out the specified release
  exec { 'gitlabr10khook-checkout-tag-from-gitlab':
    command => "git checkout master;git fetch;git checkout tags/${gitlabr10khook::release}",
    cwd     => $gitlabr10khook::install,
    user    => 'root',
    require => Exec['gitlabr10khook-checkout-from-gitlab'],
    unless  => "git name-rev --tags --name-only $(git rev-parse HEAD) | grep ${gitlabr10khook::release}",
  }
}
