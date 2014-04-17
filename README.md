Paasta
======

The intention of this project is to create Dockerfiles that prepare Docker images for Heroku-style Git application
deployment. The current base use case includes NodeJS application deployment.

## Installation

    cd paasta
    make build n=base

## Usage

    # Docker 0.10.0, build dc9c28f
    # Image paasta/*

    FROM paasta/base
    MAINTAINER *

    cd paasta/image
    ln -s path/to/Dockerfile *
    cd ../
    make build n=*

## Tests

No unit tests are currently present. They aren't currently necessary.

## Contributing

In lieu of a formal style guideline, take care to maintain the existing style.

## Release History

+ 0.0.1 Initial release
