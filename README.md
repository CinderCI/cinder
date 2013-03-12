MagnumCI
========

Continuous Delivery for iOS Apps.

MagnumCI favors convention over configuration. Of the myriad ways to organize an iOS project, MagnumCI supports a subset that still gets the job done.

<a href="http://dsharp.typepad.com/dsharp/2008/07/magnum-ci.html"><img src="http://dsharp.typepad.com/.a/6a00e54eeecc2f883400e553d59aa78834-350wi" width=175 height=234></a>

iOS projects using MagnumCI:

* have developers up and running after running a single command following `git clone`
* build your app's ipa whenever code is pushed to your GitHub repo
* publish successful builds of `master` as versions in [TestFlight](https://testflightapp.com/). The "What's New" shows changes since the last build and since the last release.
* publish successful builds of *topic branches* as comments in the pull request with links to install a version of the app with that feature
* comment and close pull requests of failed builds

Usage
-----

* `script/setup` - run this after cloning a project and you're ready to develop in Xcode. Re-run it whenever project dependencies have changed.

* `script/cibuild` - is the two-liner shell script which tells the [Janky continuous integration server](https://github.com/github/janky) how to build Ad Hoc or Enterprise versions of your app:

        #!/bin/bash
        exec "$(dirname $0)/build" --configuration Enterprise

* `bin/magnum lint` - will guide you through setting up a new project or modifying an existing project to work with MagnumCI.


New Project Quickstart
----------------------

    cd your-project
    curl -L http://git.io/axIe8Q >Gemfile
    mkdir -p script
    curl -L http://git.io/dqT6SA >script/.magnum-exec
    ( cd script ; \
      chmod +x .magnum-exec ; \
      ln -s .magnum-exec setup
    )
    bundle install --binstubs --path vendor
    bin/magnum lint
    # 10 fix errors
    # 20 bin/magnum lint
    # 30 if errors GOTO 10

Paranoid? Get `Gemfile` and `.magnum-exec` from [http://git.io/magnum_ci-skeleton](http://git.io/magnum_ci-skeleton) in place of the curl commands.

Installation for Existing Projects
----------------------------------

MagnumCI is published to [Erebor](https://github.com/detroit-labs/erebor) instead of [rubygems.org](http://rubygems.org). Add this line to the top of `Gemfile`:

    source 'https://raw.github.com/detroit-labs/erebor/gems/'

Add this line to the gems portion of `Gemfile`:

    gem 'magnum_ci'

Copy `.magnum-exec` from [this gist](http://git.io/magnum_ci-skeleton) to your `script`
directory. Mark it executable and symlink `setup` to it:

    chmod +x .magnum-exec
    ln -s .magnum-exec setup 

MagnumCI is Opinionated
-----------------------

* Ruby is an integral part of the development, build, and
  release toolchain for native iOS apps
* Ruby versions are managed by [rbenv](https://github.com/sstephenson/rbenv)
* Automation always wins
* Convention over configuration; when there's more than one way to do it, pick one