# Class: gitlabr10khook::params
# vim: set softtabstop=2 ts=2 sw=2 expandtab:
# ===========================
#
# This configures the gitlab-puppet-webhook that will take
# webhook triggers from gitlab and run r10k on your puppet server
# it currently only supports the PUSH mechanism
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Authors
# -------
# Karl Vollmer <karl.vollmer@gmail.com>
# Copyright
# ---------
# Copyright 2016 Karl Vollmer
class gitlabr10khook::params {

  # Install Path 
  $install = '/opt/gitlab-puppet-webhook'

  # Main Preferences
  ## Port to listen on
  $server = {
    port        => '8080',
    ### Secret Token (for gitlab)
    token       => undef,
    ## Environment Method
    ### DEPRECATED - Only used with legacy systems, will be removed soon
    ### Repo / Branch source
    method      => 'branch',
    ## Production Environment
    ### If your production branch is not called 'production', tell us what it is here
    prodname    => 'production',
    ### Path to Puppet Environments
    envdir      => '/etc/puppet/environments',
    ### User to Run the server as
    user        => undef,
    ### Group of the User the server runs as
    group       => undef,
    ### Path to SSL PEM file (cert + key)
    pemfile     => undef,
    ### True to run it as a daemon (will fork off), if false will not detach
    daemon      => true,
    ### E-mail server, defaults to localhost
    smtpserver  => 'localhost',
    ### From Address on outgoing e-mails
    emailfrom   => 'gitlabhook@localhost',
    ### E-mail trigger, only on production / development 
    emailmethod => 'production',
  }

  ## Logging
  $log = {
    ### Used by Python's logging
    filename  => '/var/log/gitlab10khook.log',
    ### Log File max size Default is 50mb
    maxsize   => '50331648',
    ### Log Level, Default is WARNING, valid options are CRITICAL,ERROR,WARNING,INFO,DEBUG
    level     => 'WARNING',
  }

  $r10k = {
    ### Config path
    config      => '/etc/r10k/r10k.yaml',
  }

  ## DEPRECATED - Don't learn how to use this....
  $legacy = {
    ## Enabled, defaults to false
    enabled   => false,
    ## Path where it should dump the legacy modules
    path      => 'legacy-modules',
    ## GIT Clone path, for legacy monolithic repo
    gitpath   => undef,
  }

  $footprints = {
    ## Enable Footprints integration
    enabled   => false,
    ## Workspace ID of the project we should publish to
    project   => undef,
    ## E-mail Address to send e-mail commands to (API is not implemented)
    email     => undef,
    ## Close Status String, the name of the status to switch tickets to when 
    ### We see a FIX #{NUMBER} in the commit message
    close     => undef,
  }

  $otrs = {
    ## Enable OTRS integration
    enabled   => false,
    ## To Address for OTRS
    email     => undef,
  }


}
