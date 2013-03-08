MagnumCI
========

Continuous Delivery for iOS Apps

MagnumCI is a Detroit Labs internal tool taking place out in the open.

New Project Quickstart
----------------------

    cd your-project
    curl -L http://git.io/axIe8Q >Gemfile
    mkdir -p script
    curl -L http://git.io/dqT6SA >script/.magnum-exec
    ( cd script \
      chmod +x .magnum-exec \
      ln -s .magnum-exec setup
    )
    bundle install --binsutbs --path vendor
    bin/magnum lint

Paranoid? Get `Gemfile` and `.magnum-exec` from the gist https://gist.github.com/toolbear/43adc8aac86e348f7906

Installation for Existing Projects
----------------------------------

MagnumCI is published to the Detroit Labs RubyGems source. Add this line to the top of `Gemfile`:

    source 'https://raw.github.com/detroit-labs/erebor/gems/'

Add this line to the gems portion of `Gemfile`:

    gem 'magnum_ci'

Copy `.magnum-exec` from [this gist](https://gist.github.com/toolbear/43adc8aac86e348f7906) or another project to your `script`
directory. Make it executable and symlink `setup` to it:

    chmod +x .magnum-exec
    ln -s .magnum-exec setup 
