# Class: gitlabr10khook::config
# vim: set softtabstop=2 ts=2 sw=2 expandtab:
# ===========================
# This configures the gitlab-puppet-webhook that will take
# webhook triggers from gitlab and run r10k on your puppet server
# it currently only supports the PUSH mechanism
#
# Authors
# -------
# Karl Vollmer <karl.vollmer@gmail.com>
#
# Copyright
# ---------
# Copyright 2016 Karl Vollmer.
class gitlabr10khook::config inherits gitlabr10khook {

  # Configure the Conf file
  file { "${gitlabr10khook::install}/webhook-puppet.conf":
    ensure  => file,
    mode    => '0640',
    owner   => 'root',
    group   => $::gitlabr10khook::group,
    content => template('gitlabr10khook/webhook-puppet.erb'),
  }

  $logfile = $::gitlabr10khook::log['filename']
  $logdir = dirname($logfile)

  # Make sure the log directory exists, this won't work for
  # recursive cause :( 
  file { $logdir:
    ensure => directory,
    mode   => '0770',
    owner  => $::gitlabr10khook:user,
    group  => $::gitlabr10khook:group,
  }

  # Make sure the log file exists and is writeable by the runner
  file { $logfile:
    ensure  => file,
    mode    => '0660',
    owner   => $::gitlabr10khook::user,
    group   => $::gitlabr10khook::group,
    require => File[$logdir],
  }

  # Add the service to /etc/systemd/system
  file { '/etc/systemd/system/gitlab-puppet-webhook.service':
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('gitlabr10khook/startup/gitlab-puppet-webhook.service.erb'),
  }

  # Make sure the systemd conf is in place with the correct path
  file { "${gitlabr10khook::install}/startup/systemd.conf":
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('gitlabr10khook/startup/systemd.conf.erb'),
  }

}
