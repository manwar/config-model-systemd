# config-model-systemd

check and edit systemd configuration files

## Description

This project provides a configuration editor for the 
configuration file of Systemd, i.e. all files in `~/.config/systemd/user/` or
all files in `/etc/systemd/system/`

## Usage

### invoke editor

The following command loads **user** systemd files and launch a graphical
editor:

    cme edit systemd-user

Likewise, the following command loads **system** systemd configuration
files and launch a graphical editor:

    sudo cme edit systemd

### Just check systemd configuration

You can also use cme to run sanity checks on the configuration file:

    cme check systemd-user
    cme check systemd

## Installation

On Debian, run:

    apt install cme libconfig-model-systemd-perl

You can also install this project from CPAN:

    cpanm install App::Cme
    cpanm install Config::Model::Systemd

Please follow these [instructions](README.build-from-git) to build from git.

## Re-generate systemd model files

The files in `lib/Config/Model/models/Systemd/Section` and
`lib/Config/Model/models/Systemd/Common` are generated from systemd
documentation in xml format.

To regenerate the model files, you must retrieve systemd sources. For instance, you
can retrieve Debian source package:

    apt-get source systemd

Then, from `config-model-systemd`, run:

    perl contrib/parse-man.pl -from <path to systemd source>

## More information

* [Using cme](https://github.com/dod38fr/config-model/wiki/Using-cme)
    
