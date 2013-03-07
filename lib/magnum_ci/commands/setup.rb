module MagnumCI
  command :setup do |c|
    c.syntax = 'magnum setup'
    c.summary = 'Setup project.'
    c.description = 'Set up project for development and building.'

    c.action do |args, options|
      install_cocoapods_dependencies
      import_provisioning_profiles
      say_ok 'Setup complete'
    end

    private

    def self.install_cocoapods_dependencies
      # TODO: externalize these
      private_cocoapod_repos = {
        'detroit-labs' => 'git@github.com:detroit-labs/detroit-labs-specs.git'
      }
      log 'pod', 'Updating local CocoaPods specs'
      repo_update_lines = pod!('repo update').lines
      if repo_update_lines.grep(/Updating spec repo `master'/).empty?
        log 'pod', 'Setting up public specs repo'
        pod! 'setup'
      end
      private_cocoapod_repos.each do |name, url|
        if repo_update_lines.grep(/Updating spec repo `#{name}'/).empty?
          log 'pod', "Adding #{name} specs repo"
          pod! "repo add #{name} #{url}"
        end
      end
      log 'pod', 'Installing project dependencies'
      pod! 'install --no-update'
    end

    def self.import_provisioning_profiles
      profiles_home = File.expand_path('~/Library/MobileDevice/Provisioning Profiles')
      Dir['{ad_hoc,app_store,enterprise}.mobileprovision'].each do |f|
        p7 = OpenSSL::PKCS7.new(File.read(f))
        p7.verify([], OpenSSL::X509::Store.new)
        profile = Plist::parse_xml(p7.data)
        mkdir! %{-p "#{profiles_home}"} unless File.directory? profiles_home
        log 'cp', "Importing `#{f}'"
        cp! %{#{f} "#{profiles_home}/#{profile['UUID']}.mobileprovision"}
      end
    end
  end
end
