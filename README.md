# Cinder

Continuous Delivery for iOS Apps.

Cinder favors convention over configuration. Of the myriad ways to organize an iOS project, Cinder supports a subset that still gets the job done.

<a href="http://www.flickr.com/photos/cindy_cinder/6063851300/" title="Flaming Butterfly and Flowers by Cinder's, on Flickr"><img src="http://farm7.staticflickr.com/6204/6063851300_6c81f2360d.jpg" width="150" height="200" alt="Flaming Butterfly and Flowers"></a>

iOS projects using Cinder:

* have developers up and running after running a single command following `git clone`
* build your app's ipa whenever code is pushed to your GitHub repo
* publish successful builds of `master` as versions in [TestFlight](https://testflightapp.com/). <span style="color:#999">The "What's New" shows changes since the last build and since the last release.</span>
* <span style="color:#999">publish successful builds of *topic branches* as comments in the pull request with links to install a version of the app with that feature</span>
* <span style="color:#999">comment and close pull requests of failed builds</span>

Items in <span style="color:#999">de-emphasized text</span> are still being developed.

## Usage

* `script/setup` - run this after cloning a project and you're ready to develop in Xcode. Re-run it whenever project dependencies have changed.

* `script/cibuild` - is the two-liner shell script which tells the [Janky continuous integration server](https://github.com/github/janky) how to build Ad Hoc or Enterprise versions of your app:

        #!/bin/bash
        exec "$(dirname $0)/build" --configuration Enterprise

* `bin/cinder lint` - will guide you through setting up a new project or modifying an existing project to work with Cinder.


## New Project Quickstart

In the top-level of your project run:

    ruby -e "$(curl -fsSL https://raw.github.com/detroit-labs/cinder/hot)"

This is a one-time initialization that only one developer must complete. Afterwards, anyone cloning the project can simply run:

    script/setup

## Installation for Existing Projects

If your project doesn't use Bundler (e.g. doesn't have a `Gemfile`) then follow **New Project Quickstart** above.

Cinder is available on Rubygems. Add this line to your `Gemfile`:

    gem 'cinder'

Cinder expects that you use binstubs with Bundler and vendor gems under `.bundle`. Run:

    bundle install --binstubs --path .bundle
    git add .bundle/config
    echo '/.bundle/ruby/' >>.gitignore
    
Henceforth `bundle install` without flags is sufficient.

The `cinder` CLI should now be available under `bin/`. It will guide you the rest of the way:

    bin/cinder lint
    # 10 fix errors
    # 20 bin/cinder lint
    # 30 if errors GOTO 10

## Cinder is Opinionated

* Ruby is an integral part of the development, build, and
  release toolchain for native iOS apps
* Ruby versions are managed by [rbenv](https://github.com/sstephenson/rbenv)
* Automation always wins
* Convention over configuration; when there's more than one way to do it, pick one

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

Cinder is built and maintained at [Detroit Labs](http://detroitlabs.com) by [Tim Taylor](http://github.com/toolbear) and [Nate West](http://github.com/nwest).

![Detroit Labs](http://i.imgur.com/OgGhz1U.png)

## License

Cinder is released under the [MIT](http://opensource.org/licenses/MIT) license.
