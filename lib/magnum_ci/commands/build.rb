module MagnumCI
  command :build do |c|
    c.syntax = 'magnum build [OPTIONS]'
    c.summary = 'Build & publish a release.'
    c.description = 'Build a release. For AdHoc or Enterprise builds against `master`, publish to TestFlight.'

    c.option '-c', '--configuration CONFIGURATION', 'Configuration used to build. One of AdHoc, AppStore, or Enterprise. Defaults to AdHoc.'

    c.action do |args, options|
      options.default :configuration => 'AdHoc'

      workspaces = Dir["*.xcworkspace"].grep(/^(.*)\.xcworkspace$/){$1}
      say_error "No Xcode workspace found" and abort if workspaces.empty?
      say_error "There can be only one workspace" and abort if workspaces.length > 1
      name = workspaces.first
      keychain_file = "#{ENV['HOME']}/Library/Keychains/#{options.configuration.snake_case}.keychain"

      if File.exists?(keychain_file)
        args = [
                keychain_file,
                "/Library/Keychains/System.keychain"
               ]
        log 'security', "Using #{options.configuration.snake_case}.keychain"
        security! "list-keychains -s #{args.join(" ")}"
        security! %{default-keychain -s "#{keychain_file}"}
        security! %{unlock-keychain -p "#{ENV['CI_KEYCHAIN_PASSWORD']}" "#{keychain_file}"}
      end

      short_sha1 = git!("rev-parse --short #{ENV['JANKY_SHA1'] || 'HEAD'}").strip
      log 'plist', "Setting CFBundleVersion to `#{short_sha1}'"
      PlistBuddy! %{-c "Set :CFBundleVersion #{short_sha1}" "#{name}/#{name}-Info.plist"}
      log 'ipa', "Building an ipa with configuration `#{options.configuration}' and scheme `#{name}'"
      ipa! "build --trace -c #{options.configuration} -s #{name}"
      say_ok "Did all the things for #{name}"
    end
  end
end
