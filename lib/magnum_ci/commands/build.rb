module MagnumCI
  command :build do |c|
    c.syntax = 'magnum build [OPTIONS]'
    c.summary = 'Build & publish a release.'
    c.description = 'Build a release. For AdHoc or Enterprise builds against `master`, publish to TestFlight.'

    c.option '-c', '--configuration CONFIGURATION', 'Configuration used to build. One of AdHoc, AppStore, or Enterprise. Defaults to AdHoc.'

    c.action do |args, options|
      options.default :configuration => 'AdHoc'

      name = determine_workspace
      use_keychain options.configuration.snake_case
      set_bundle_version name
      build_ipa options.configuration, name
      say_ok "Did all the things for #{name}"
    end

    private

    def self.determine_workspace
      workspaces = Dir["*.xcworkspace"].grep(/^(.*)\.xcworkspace$/){$1}
      say_error "No Xcode workspace found" and abort if workspaces.empty?
      say_error "There can be only one workspace" and abort if workspaces.length > 1
      workspaces.first
    end

    def self.use_keychain keychain_name
      keychain_file = "#{ENV['HOME']}/Library/Keychains/#{keychain_name}.keychain"
      if File.exists?(keychain_file)
        args = [
                keychain_file,
                "/Library/Keychains/System.keychain"
               ]
        log 'security', "Using #{keychain_name}.keychain"
        security! "list-keychains -s #{args.join(" ")}"
        security! %{default-keychain -s "#{keychain_file}"}
        security! %{unlock-keychain -p "#{ENV['CI_KEYCHAIN_PASSWORD']}" "#{keychain_file}"}
      end
    end

    def self.set_bundle_version name
      short_sha1 = git!("rev-parse --short #{ENV['JANKY_SHA1'] || 'HEAD'}").strip
      log 'plist', "Setting CFBundleVersion to `#{short_sha1}'"
      PlistBuddy! %{-c "Set :CFBundleVersion #{short_sha1}" "#{name}/#{name}-Info.plist"}
    end

    def self.build_ipa configuration, name
      log 'ipa', "Building an ipa with configuration `#{configuration}' and scheme `#{name}'"
      ipa! "build --trace -c #{configuration} -s #{name}"
    end
  end
end
