# Class: gitlabr10khook::service
# vim: set softtabstop=2 ts=2 sw=2 expandtab:
# ===========================
# Authors
# -------
# Karl Vollmer <karl.vollmer@gmail.com>
#
# Copyright
# ---------
# Copyright 2016 Karl Vollmer.
class gitlabr10khook::service inherits gitlabr10khook {

  # Define service, assumes the systemd stuff worked 
  service { 'gitlabr10khook-server':
    ensure  => true,
    enable  => true,
    name    => 'gitlab-puppet-webhook',
  }

}
