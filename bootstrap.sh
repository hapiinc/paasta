#!/bin/sh

# This script is meant for bootstrapping the Paasta runtime environment.
# The Paasta runtime environment depends on Docker. Docker is "an open source project to pack, ship and run any
# application as a lightweight container."
#
# Operating Systems or Linux Kernels that the Paasta runtime environment supports are that which Docker supports.
# We prefer the Ubuntu installation as it is the officially-tested version.
# @see http://docs.docker.io/en/latest/installation/
#
# Ubuntu Dependencies
# Linux Kernel 3.8
#
# Due to a bug in LXC, Docker works best on the 3.8 kernel.
# Ubuntu Precise 12.04 (LTS) (64-bit) comes with a 3.2 kernel.
# To update the kernel (to a kernel with AUFS built in), follow these steps:
# sudo apt-get update
# sudo apt-get install linux-image-generic-lts-raring linux-headers-generic-lts-raring
# sudo reboot

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

# Attempt to install the Docker runtime environment in a variety of ways.
# The installation script does some verification of Docker's existence in the system before attempting an installation.

# If wget exists, then attempt to retrieve the Docker installation shell script, and execute it as root.
if commandExists wget;
then
    # wget [option]... [URL]...
    # -O file, --output-document=file
    # The documents will not be written to the appropriate files, but all will be concatenated together and written to
    # file. If - is used as file, documents will be printed to standard output, disabling link conversion.
    # (Use ./- to print to a file literally named -.)
    # Use of -O is not intended to mean simply "use the name file instead of the one in the URL;" rather, it is
    # analogous to shell redirection: wget -O file http://foo is intended to work like wget -O - http://foo > file;
    # file will be truncated immediately, and all downloaded content will be written there.
    # -q, --quiet
    # Turn off Wget's output.
    #
    # This installation path should work at all times.
    wget --quiet --output-document=- https://get.docker.io/ | sudo sh;
    # If installation succeeded, then the Docker daemon should be running at this point.
    # If for any reason the Docker daemon is not running after installation, then run:
    # sudo docker -d &
# Else if curl exists, then attempt to retrieve the Docker installation shell script, and execute it as root.
elif commandExists curl;
then
    # curl [options] [URL...]
    # -L, --location
    # (HTTP/HTTPS) If the server reports that the requested page has moved to a different location (indicated with a
    # Location: header and a 3XX response code), this option will make curl redo the request on the new place.
    # If used together with -i, --include or -I, --head, headers from all requested pages will be shown.
    # When authentication is used, curl only sends its credentials to the initial host. If a redirect takes curl to a
    # different host, it won't be able to intercept the user+password. See also --location-trusted on how to change
    # this.
    # You can limit the amount of redirects to follow by using the --max-redirs option. When curl follows a redirect
    # and the request is not a plain GET (for example POST or PUT), it will do the following request with a GET if the
    # HTTP response was 301, 302, or 303. If the response code was any other 3xx code, curl will re-send the following
    # request using the same unmodified method.
    # -s, --silent
    # Silent or quiet mode. Don't show progress meter or error messages. Makes Curl mute.
    #
    # This installation path should work at all times.
    curl --silent --location https://get.docker.io/ | sudo sh;
    # If installation succeeded, then the Docker daemon should be running at this point.
    # If for any reason the Docker daemon is not running after installation, then run:
    # sudo docker -d &
else
    echo >&2 'Error: "wget" or "curl" commands appear to not exist.';
    echo >&2 'The Docker installation script could not be downloaded.';
fi
