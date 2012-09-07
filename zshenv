# Try to speed up zsh start-up.
# See email 
# Date: Sun, 14 Aug 2011 11:06:02 -0700
# From: Bart Schaefer <schaefer@brasslantern.com>
# To: zsh-users@zsh.org
# Subject: Re: "Once-a-day" long delay before startup

unsetopt hashlistall hashcmds hashdirs
# NOTE: hashlistall has to be re-enabled in .zshrc . Otherwise sudo
# command-completion is broken.
