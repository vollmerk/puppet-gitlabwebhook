# gitlabr10khook

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with gitlabr10khook](#setup)
    * [What gitlabr10khook affects](#what-gitlabr10khook-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with gitlabr10khook](#beginning-with-gitlabr10khook)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module installs a simple Python webserver that accepts webhook PUSH notifications
from Gitlab, and runs R10k to bring your puppet server up to date. It also
has some legacy support for monolithic puppet repos. 

The Project for the python webserver this installs can be found at
https://github.com/vollmerk/gitlab-puppet-webhook

The Python script can also trigger e-mails to Footprints or OTRS ticketing
systems based on the commit mesage

## Setup

### What gitlabr10khook affects 

* Updates python-daemon module
* Installs pip
* Installs git

### Setup Requirements 

Every effort was made such that this manifest should attempt to install 
everything it needs, but it expects python, pip, some modules, openssl
and git to be available

### Beginning with gitlabr10khook

The very basic steps needed for a user to get the module up and running. This
can include setup steps, if necessary, or it can be an example of the most
basic use of the module. Below is a minimal declaration of the webhook

```
class { 'gitlabr10khook':
  server => {
    token => 'mytoken',
    user  => 'myuser',
    group => 'mygroup',
    pemfile => 'cert.pem',
   },
}
```
It's unlikely that the above will give you a fully functional install but
it should at least run. You will need to add the webhook to Your Gitlab
project - Instructions can be found at https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/web_hooks/web_hooks.md

A installation of the server that runs on port 8080 as the user gitlabwebhook with otrs integration enabled
would look like this
```
class { 'gitlabr10khook':
  server => {
    token     => 'example',
    user      => 'gitlabwebhook',
    group     => 'gitlabwebhook',
    pemfile   => '/opt/gitlab-puppet-webhook/server.pem',
    emailfrom => 'gitlabwebhook@example',
  },
  otrs => {
    enabled => true,
    email   => 'otrs@example',
  }
}
```

## Usage

The webhook declration is made up of the following six hashes

* server
* log
* r10k
* legacy
* footprints
* otrs

The certificate for the python webserver, as defined by `pemfile` must be a PEM file that is a combination of
your certifacte and the key. 

Both E-mail based ticketing integrations assume that `FIX #120398` indicates that ticket 120398 has been 
resolved, if you just want to reference a ticket simply put `#120398`. You can reference multiple tickets
in a single commit. By default the ticketing system will only be updated when things are moved into the
branch that is defined to be your production environment (Default of `production`). 

## Reference

**Parameters**

Required parameters are indicated by **bold**

`install` Specifies the directory to clone the gitlab webhook into, this is done via a git clone
* Default: /opt/gitlab-puppet-webhook

`server` Is a hash that defines how the server is to be setup, the hash takes the following arguments

`server::port` Specifies the TCP port that the python daemon should listen on for notifications from gitlab. This 
module does not adjust your firewall
 * Default: 8080

**`server::token`** Sets the secret token that must be submitted with the push from gitlab, this requires newer versions of
gitlab, but is seen as a require security feature.
* Default: undef

`server::method` Defines the method to be used for deploying puppet modules to the server, branch is the only 
valid method, but it is kept due to legacy code. DEPRECATED
* Default: branch

`server::prodname` The name of your production branch, this does not have to be `production`, it is used to determine if e-mails
should be sent based on the `emailmethod` parameter
* Default: production

`server::envdir` The path where it should check out the puppet environments, this is only needed by the legacy code. DEPRECATED
* Default: /etc/puppet/environments

**`server::user`** Defines the user that the python daemon should run as, the daemon should be launched by root and will fork off to 
the specified user, also used for file permission setups
* Default: undef

**`server::group`** Used to make sure that permissions are set correctly
* Default: undef

**`server:pemfile`** SSL PEM file for the server, must be certificate + key
* Default: undef

`server::daemon` Should the application fork off and disconnect, or remain connected to the terminal. Set to false for debug
* Default: true

`server::smtpserver` Hostname of your mailserver that will accept mail from the daemon
* Default: localhost

`server::emailfrom` The FROM: address used on outgoing e-mail, you should change this as most restrictive smtp servers will reject @localhost mail
* Default: gitlab@localhost

`server::emailmethod` Only send e-mails when the `server::prodname` branch is being modified, valid options are `production` `development`. If its 
set to development, e-mails will not be re-sent when you merge into production
* Default: production

`log` A has that configures how logging should be handled for the python webserver

`log::filename` Define the file that the daemon should log to, will attempt to set correct permissions for this file on install
* Default: /var/log/gitlabr10khook.log

`log::maxsize` Set the max size of the log file (will be roated when reached). Defaults to 50MB
* Default: 50331648

`log::level` The Log level from the webhook daemon, valid options are `CRITICAL` `ERROR` `WARNING` `INFO` `DEBUG`
* Default: WARNING

`r10k` Hash that contains the r10k configuration, really seems unneeded, but ooh well

`r10k::config` Path to the r10k config file, needed when launching r10k
* Default /etc/r10k/r10k.yaml

`legacy::enabled` Legacy monolithic puppet module repo functionality, just don't use this... DEPRECATED
* Default: false

`legacy::path` The path under your production environment where the legacy monolithic repo will be checked out
* Default: legacy-modules

**`legacy::gitpath`** Only required if `legacy::enabled=true` This is the git repo path for your monolithic puppet module pile
* Default: undef

`footprints::enabled` Enable this to have the daemon send emails to Footprints on commit if a ticket is referenced via #12039
supports the use of FIX #12039 to close the ticket
* Default: false

**`footprints::project`** Required if using footprints, the numeric value of the project that you wish ticket updates to be
submitted to, The system does not currently support multiple projects
* Default: undef

**`footprints::email`** Required if using footprints, the e-mail addres to end e-mail updates to, this assumes that your
footprints accepts e-mail commands
* Default: undef

**`footprints::close`** The status in your footprints that indicates that the ticket is closed, this is a string value
* Default: undef

`otrs::enabled` Enable this to have the daemon send emails to an OTRS instance, OTRS must allow special headers
to be received, so that the updates appear to be from agents
* Default: false

**`otrs::email`** E-mail address for your OTRS instance, updates will be sent here
* Default: undef

## Limitations

Currently only implemented for RedHat CentOS and Debian, and only for systemd 

## Development

Contributions will be accepted, please make sure any code you commit follows
all of the Puppet Lint checks. Thanks!

Karl Vollmer <karl.vollmer@gmail.com>

