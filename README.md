MagnumCI
========

Continuous Delivery for iOS Apps.

MagnumCI favors convention over configuration. Of the myriad ways to organize an iOS project, MagnumCI supports a subset that still gets the job done.

<a href="http://dsharp.typepad.com/dsharp/2008/07/magnum-ci.html"><img src="http://dsharp.typepad.com/.a/6a00e54eeecc2f883400e553d59aa78834-350wi" width=175 height=234></a>

iOS projects using MagnumCI:

* have developers up and running after running a single command following `git clone`
* build your app's ipa whenever code is pushed to your GitHub repo
* publish successful builds of `master` as versions in [TestFlight](https://testflightapp.com/). <span style="color:#999">The "What's New" shows changes since the last build and since the last release.</span>
* <span style="color:#999">publish successful builds of *topic branches* as comments in the pull request with links to install a version of the app with that feature</span>
* <span style="color:#999">comment and close pull requests of failed builds</span>

Items in <span style="color:#999">de-emphasized text</span> are still being developed.

Usage
-----

* `script/setup` - run this after cloning a project and you're ready to develop in Xcode. Re-run it whenever project dependencies have changed.

* `script/cibuild` - is the two-liner shell script which tells the [Janky continuous integration server](https://github.com/github/janky) how to build Ad Hoc or Enterprise versions of your app:

        #!/bin/bash
        exec "$(dirname $0)/build" --configuration Enterprise

* `bin/magnum lint` - will guide you through setting up a new project or modifying an existing project to work with MagnumCI.


New Project Quickstart
----------------------

In the top-level of your project run:

    curl -L http://git.io/axIe8Q >Gemfile
    bundle install --binstubs --path .bundle
    bin/magnum lint
    # 10 fix errors
    # 20 bin/magnum lint
    # 30 if errors GOTO 10

This is a one-time initialization that only one developer must complete. Afterwards, anyone cloning the project can simply run:

    script/setup

Installation for Existing Projects
----------------------------------

If your project doesn't use Bundler (e.g. doesn't have a `Gemfile`) then follow **New Project Quickstart** above.

Add this line to the top of `Gemfile`:

    source 'https://raw.github.com/detroit-labs/erebor/gems/'

Add this line to the gems portion of `Gemfile`:

    gem 'magnum_ci'

MagnumCI expects that you use binstubs with Bundler and vendor gems under `.bundle`. Run:

    bundle install --binstubs --path .bundle
    git add .bundle/config
    echo '/.bundle/ruby/' >>.gitignore
    
Henceforth `bundle install` without flags is sufficient.

The `magnum` CLI should now be available under `bin/`. It will guide you the rest of the way:

    bin/magnum lint
    # 10 fix errors
    # 20 bin/magnum lint
    # 30 if errors GOTO 10

MagnumCI is Opinionated
-----------------------

* Ruby is an integral part of the development, build, and
  release toolchain for native iOS apps
* Ruby versions are managed by [rbenv](https://github.com/sstephenson/rbenv)
* Automation always wins
* Convention over configuration; when there's more than one way to do it, pick one