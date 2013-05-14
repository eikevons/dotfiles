# vim:ft=sh

# this should work both in bash and zsh
umask 0022

# NOTE: To set environment variables use ${VAR_NAME:+:$VAR_NAME} to make sure
# that ':' is only added if $VAR_NAME was previously set.

# # This is needed by pyminuit to work
# if [ -d /usr/lib/root/5.18 ]; then
    # # EIKE: This shouldn't be necessary anymore, put into
    # # /etc/ld.so.conf.d/root-system-common.conf instead.
    # # export LD_LIBRARY_PATH="/usr/lib/root/5.18:${LD_LIBRARY_PATH}"

    # export PYTHONPATH="/usr/lib/root/5.18${PYTHONPATH:+:$PYTHONPATH}"
# fi

# handle homeusr stuff
HOMEUSR="${HOME}/.local"
if [ -d $HOMEUSR ]; then
    if [ -d ${HOMEUSR}/bin ]; then
        export PATH="${HOMEUSR}/bin${PATH:+:$PATH}"
    fi

    if [ -d ${HOMEUSR}/lib ]; then
        export LD_LIBRARY_PATH="${HOMEUSR}/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    fi

    # if [ -d ${HOMEUSR}/lib/python ] ; then
        # export PYTHONPATH="${HOMEUSR}/lib/python${PYTHONPATH:+:$PYTHONPATH}"
    # fi

    # This is not needed anymore since .../python2.5/site-packages links to
    # .../python/
    # if [ -d ${HOMEUSR}/lib/python2.5/site-packages/ ] ; then
        # export PYTHONPATH="${HOMEUSR}/lib/python2.5/site-packages/:${PYTHONPATH}"
    # fi

    if [ -d ${HOMEUSR}/man ] ; then
        export MANPATH="${HOMEUSR}/man${MANPATH:+:$MANPATH}"
    fi
fi

# if [ -d ${HOME}/projects/rivet/helpers/generators/liblinks ]; then
    # export AGILE_GEN_PATH=${HOME}/projects/rivet/helpers/generators/liblinks
# fi
