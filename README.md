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

Webhook for updating Puppet using R10K from Gitlab repos

This is a simple Python webserver that accepts webhook PUSH notifications
from Gitlab, and runs R10k to bring your puppet server up to date. It also
has some legacy support for monolithic puppet repos. 

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
basic use of the module.

## Usage

This section is where you describe how to customize, configure, and do the
fancy stuff with your module here. It's especially helpful if you include usage
examples and code samples for doing things with your module.

## Reference

Here, include a complete list of your module's classes, types, providers,
facts, along with the parameters for each. Users refer to this section (thus
the name "Reference") to find specific details; most users don't read it per
se.

## Limitations

Currently only implemented for CentOS and Debian, and only for systemd 

## Development

Contributions will be accepted, please make sure any code you commit follows
all of the Puppet Lint checks. Thanks!

Karl Vollmer <karl.vollmer@gmail.com>

