SHELL = /bin/sh

DOTFILES := $(CURDIR)

ZSHFUNCTIONS := $(wildcard zshfunctions/*[^~])

all: vim-setup zsh-setup colors X-setup screen-setup gnupg-setup

vim-setup:  $(addprefix $(HOME)/., vim vimrc)

zsh-setup: $(addprefix $(HOME)/., zprofile zshenv zshrc alias) zshfunctions

zshfunctions: $(addprefix $(HOME)/., $(ZSHFUNCTIONS))

colors: $(addprefix $(HOME)/., dircolors.darkbg dircolors.lightbg)

X-setup: $(addprefix $(HOME)/., Xresources)

screen-setup: $(addprefix $(HOME)/., screenrc)

gnupg-setup: $(addprefix $(HOME)/., gnupg/gpg.conf gnupg/gpa.conf gnupg/pubring.gpg gnupg/pubring.kbx)

bash-setup: $(addprefix $(HOME)/., bashrc bash_profile alias)

# Common rule to generate symlinks to files/directories in dotfiles/
$(HOME)/.%: %
	@if [ ! -d $(@D) ]; then\
	    echo " [mkdir]  mkdir -p $(@D)" ;\
	    mkdir -p $(@D); \
	fi
	@echo " [ln]    link $< to ~/.$<"
	@ln -sT $(DOTFILES)/$< $@
