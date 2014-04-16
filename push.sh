#!/bin/sh

# This script is meant for pushing the Paasta runtime environment to a destination server.
# The destination server will be connected to through a secure channel established with SSH.
# The expected setup is to have an SSH configuration file in the SSH directory of the current user ( ~/.ssh/config ).
#
# Per User Configuration Example:
#
# Host digitalocean
# HostName 255.255.255.255
# IdentityFile ~/.ssh/digitalocean/id_rsa
# User root
#
# @see http://www.openbsd.org/cgi-bin/man.cgi?query=ssh_config&sektion=5

# set: set [--abefhkmnptuvxBCHP] [-o option] [arg ...]
# -e Exit immediately if a command exits with a non-zero status.
set -e;

# Convenience function to check if a given command exists.
# Standard Output and Standard Error are redirected to the null device ( /dev/null ).
commandExists() {
    # Device nodes on Unix-like systems do not necessarily have to correspond to physical devices. Nodes that lack
    # this correspondence form the group of pseudo-devices. They provide various functions handled by the operating
    # system. Some of the most commonly used (character-based) pseudo-devices include:
    #
    # /dev/null
    # Accepts and discards all input; produces no output.
    #
    # command: command [-pVv] command [arg ...]
    # Runs COMMAND with ARGS ignoring shell functions. If you have a shell function called `ls', and you wish to call
    # the command `ls', you can say "command ls". If the -p option is given, a default value is used for PATH that is
    # guaranteed to find all of the standard utilities. If the -V or -v option is given, a string is printed
    # describing COMMAND. The -V option produces a more verbose description.
    command -v "$@" > /dev/null 2>&1;
}

# Default Values for Source and Destination.
SOURCE="./";
DESTINATION="digitalocean:~/paasta";

# If a single argument is provided to the arguments vector, then assume it is the Source.
if [ ! -z "$1" ];
then
    SOURCE="$1";
fi

# If a second argument is provided to the arguments vector, then assume it is the Destination.
if [ ! -z "$2" ];
then
    DESTINATION="$2";
fi

# Log the Source and Destination.
echo '------------------------------';
echo 'Source:';
echo ${SOURCE};
echo 'Destination:';
echo ${DESTINATION};
echo '------------------------------';

# Attempt to push Paasta runtime environment in a variety of ways.

# If rsync exists, then attempt to push the Paasta runtime environment using it over an encrypted channel.
if commandExists rsync;
then
    # rsync [OPTION]... SRC [SRC]... [USER@]HOST:DEST
    # For remote transfers, a modern rsync uses ssh for its communications, but it may have been configured to use a
    # different remote shell by default, such as rsh or remsh.
    # -a, --archive
    # archive mode; equals -rlptgoD (no -H,-A,-X)
    # -z, --compress
    # compress file data during the transfer
    # -C, --cvs-exclude
    # auto-ignore files in the same way CVS does
    # --safe-links
    # This tells rsync to ignore any symbolic links which point outside the copied tree. All absolute symlinks are
    # also ignored. Using this option in conjunction with --relative may give unexpected results.
    # -v, --verbose
    # increase verbosity
    OPTIONS="--archive --compress --cvs-exclude --verbose";
    rsync ${OPTIONS} ${SOURCE} ${DESTINATION};
# If scp exists, then attempt to push the Paasta runtime environment using it over an encrypted channel.
# Please don't use scp. It's pretty terrible.
elif commandExists scp;
then
    # scp [-12346BCEpqrv] [-c cipher] [-F ssh_config] [-i identity_file] [-l limit] [-o ssh_option] [-P port]
    #     [-S program] [[user@]host1:]file1 ... [[user@]host2:]file2
    # scp copies files between hosts on a network. It uses ssh(1) for data transfer, and uses the same authentication
    # and provides the same security as ssh(1). Unlike rcp(1), scp will ask for passwords or passphrases if they are
    # needed for authentication.
    # -C' Compression enable. Passes the -C flag to ssh(1) to enable compression.
    # -r' Recursively copy entire directories. Note that scp follows symbolic links encountered in the tree traversal.
    # -v' Verbose mode. Causes scp and ssh(1) to print debugging messages about their progress. This is helpful in
    # debugging connection, authentication, and configuration problems.
    OPTIONS="-C -r -v";
    scp ${OPTIONS} ${SOURCE} ${DESTINATION};
else
    echo >&2 'Error: "rsync" and "scp" commands appear to not exist.';
    echo >&2 'The Paasta runtime environment could not be pushed.';
fi
