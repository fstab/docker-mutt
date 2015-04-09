docker-mutt
===========

Run your favorite mail client [mutt](http://www.mutt.org) in a [Docker](http://docker.io) container without installing [mutt](http://www.mutt.org) on your host system.

Configuration
-------------

The [fstab/mutt](https://registry.hub.docker.com/u/fstab/mutt) docker image contains only the [mutt](http://www.mutt.org) and [msmtp](http://msmtp.sourceforge.net/) applications, but no configuration. The configuration must be created in a directory _on the host system_ and mounted as a volume to `/home/mutt` in the container.

*On the host system, create a folder `~/.mutt/`. In this folder, create the configuration files as follows:*

msmtp configuration
-------------------

[msmtp](http://msmtp.sourceforge.net/) is a sendmail replacement that can be used for sending mail via an SMTP server. It is configured _on the host system_ in a file `~/.mutt/.msmtprc` as follows:

```
defaults
logfile ~/.msmtp.log

account alice
host mail.example.com
from alice@example.com
auth on
user alice
password xxxxxxxx

account default : alice
```

mutt configuration
------------------

[mutt](http://www.mutt.org) is configured _on the host system_ in `~/.mutt/.muttrc`. 

```
#########################
# sending with msmtp
#########################

set sendmail="/usr/bin/msmtp"
set use_from=yes
set realname="Alice Springs"
set from=alice@example.com
set envelope_from=yes

#########################
# receiving with imap
#########################

set folder="imaps://alice:xxxxxxx@mail.example.com"
set spoolfile="+INBOX"
set record="+Sent"
set postponed="+Drafts"
set trash="+Trash"
set header_cache = "/home/mutt/.mutt_cache"
set message_cachedir = "/home/mutt/.mutt_cache"

# Automatically poll subscribed mailboxes for new mail (new in 1.5.11)
set imap_check_subscribed
# Reduce polling frequency to a sane level
set mail_check=60

#########################
# usability
#########################

set editor="vim"
```

Create the mutt cache directory `~/.mutt/.mutt_cache/` _on the host system_ and change access rights of `~/.mutt/` to `700`.

Run from Docker Hub
-------------------

A pre-built image is available on [Docker Hub](https://registry.hub.docker.com/u/fstab/mutt). Once the configuration is created _on the host system_, the container can be run as follows:

```bash
docker run -v ~/.mutt:/home/mutt -t -i fstab/mutt
```

The container will start up with the [mutt](http://www.mutt.org) mail client.

Build from Source
-----------------

1. Make sure [Docker](https://www.docker.com) is installed.
2. Clone [fstab/docker-mutt](https://github.com/fstab/docker-mutt) from GitHub.
   
   ```bash
   git clone https://github.com/fstab/docker-mutt.git
   ```
3. Build the docker image
   
   ```bash
   cd docker-mutt
   docker build -t="fstab/mutt" .
   ```
   
4. Once the configuration is is created _on the host system_, the docker container can be run as follows:
   
   ```bash
   docker run -v ~/.mutt:/home/mutt -t -i fstab/mutt
   ```

Create an alias
---------------

If everything works fine, add an _alias_ to the `~/.bashrc` so that the container can be run with a simple `mutt` command:

```bash
alias mutt="docker run -v ~/.mutt:/home/mutt -t -i fstab/mutt"
```
