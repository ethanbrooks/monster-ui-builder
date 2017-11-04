# MonsterUI 4.1.x Builder
[![Build Status](https://travis-ci.org/telephoneorg/monster-ui-builder.svg?branch=master)](https://travis-ci.org/telephoneorg/monster-ui-builder)


## Maintainer
Joe Black <me@joeblack.nyc> | [github](https://github.com/joeblackwaslike)


## Description
This is just a builder for MonsterUI 4.1.x, which is used in [docker-monster-ui](https://github.com/telephoneorg/docker-monster-ui).


## Build Environment
Build environment variables are often used in the build script to bump version numbers and set other options during the docker build phase.  Their values can be overridden using a build argument of the same name.
* `MONSTER_UI_VERSION`: supplied to `git clone -b` when cloning the monster-ui repo.

The following variables are standard in most of our dockerfiles to reduce duplication and make scripts reusable among different projects:
* `APP`: monster-ui
* `USER`: monster-ui
* `HOME` /build
