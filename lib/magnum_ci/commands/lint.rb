require 'xcodeproj'
require 'extlib'
require 'cocoapods' # TODO: change to cocoapods-core once ~> 0.17

module MagnumCI
  class Linter
    def lint options, args
      abort unless _lint
    end

    def _lint acc = {}
      acc &&=  detect_projects               acc
      acc &&=  detect_workspaces             acc
      acc &&=  determine_name                acc
      acc &&=  check_podfile                 acc
      acc &&=  check_workspace               acc
      acc &&=  check_single_project          acc
      acc &&=  check_multiple_projects       acc
      acc &&=  load_project                  acc
      acc &&=  detect_targets                acc
      acc &&=  check_single_target           acc
      acc &&=  check_multiple_targets        acc
      acc &&=  detect_build_configs          acc
      acc &&=  check_app_store_config        acc
      acc &&=  check_testing_configs         acc
      acc &&=  detect_provisioning_profiles  acc
      acc &&=  check_provisioning_profiles   acc

      say_ok 'OK to go' if acc
      acc != nil
    end

    private

    def detect_projects acc
      acc[:projects] = projects = Dir["*.xcodeproj"].map {|f| File.basename(f)}.grep(/^(.*)\.xcodeproj$/){$1}
      say_error "No Xcode project found" and return nil if projects.empty?
      acc
    end

    def detect_workspaces acc
      acc[:workspaces] = Dir["*.xcworkspace"].map {|f| File.basename(f)}.grep(/^(.*)\.xcworkspace$/){$1}
      acc
    end

    def determine_name acc
      if acc[:workspaces].length == 1
        acc[:name] = acc[:workspaces].first
      elsif acc[:projects].length == 1
        acc[:name] = acc[:projects].first
      end
      acc
    end

    def check_podfile acc
      result = acc
      file = Dir['Podfile'].first
      say_error "No CocoaPods Podfile found" and return nil unless file
      podfile = Pod::Podfile.from_file file
      target = podfile.target_definitions[acc[:name].to_sym] if acc[:name]
      target ||= podfile.target_definitions[:default]
      platform = target.platform.name if target.platform
      say_error 'CocoaPods platform must be iOS' and result = nil unless platform == :ios
      say_error 'Must have at least one CocoaPods dependency' and result = nil if target.dependencies.empty?
      result
    end

    def check_workspace acc
      workspaces = Dir["*.xcworkspace"].map {|f| File.basename(f)}.grep(/^(.*)\.xcworkspace$/){$1}
      say_error "No Xcode workspace found" and return nil if workspaces.empty?
      say_error "There can be only one Xcode workspace" and return nil if workspaces.length > 1
      acc[:workspace] = workspace = workspaces.first
      say_error "Workspace name `#{workspace}' must not contain whitespace" and return nil if workspace =~ /\s/
      say_warning "Workspace name `#{workspace}' should be CamelCase" unless workspace =~ /^[[:upper:]]\S*(?:[[:upper:]]\s*)*$/
      acc
    end

    def check_single_project acc
      return acc if acc[:projects].length > 1

      acc[:project] = acc[:projects].find { |p| p == acc[:workspace] }
      say_error "Xcode project name `#{acc[:projects].first}' must match workspace name `#{acc[:workspace]}'" and return nil unless acc[:project]
      acc
    end

    def check_multiple_projects acc
      return acc if acc[:projects].length == 1

      acc[:project] = acc[:projects].find { |p| p == acc[:workspace] }
      say_error "One Xcode project name must match workspace name `#{acc[:workspace]}'" and return nil unless acc[:project]
      acc
    end

    def load_project acc
      acc[:xcodeproj] = Xcodeproj::Project.new "#{acc[:project]}.xcodeproj"
      acc
    end

    def detect_targets acc
      acc[:targets] = acc[:xcodeproj].targets
      say_error "Xcode project must have at least one target" and return nil if acc[:targets].empty?
      acc
    end

    def check_single_target acc
      return acc if acc[:targets].length > 1

      acc[:target] = target = acc[:targets].first
      say_error "Target name `#{target.name}' must match workspace name `#{acc[:workspace]}'" and return nil unless target.name == acc[:workspace]
      acc
    end

    def check_multiple_targets acc
      return acc if acc[:targets].length == 1

      acc[:target] = acc[:targets].find { |t| t.name == acc[:workspace] }
      say_error "One Xcode target name must match workspace name `#{acc[:workspace]}'" and return nil unless acc[:target]
      acc
    end

    def detect_build_configs acc
      a = acc[:xcodeproj].build_configurations
      acc[:build_configs] = configs = a.find_all { |c| c.name =~ /^(?:AdHoc|AppStore|Enterprise)$/ }.each_with_object({}) { |c,h| h[c.name.snake_case.to_sym] = c }
      acc
    end

    def check_testing_configs acc
      configs = acc[:build_configs].find_all { |k,v| k == :ad_hoc || k == :enterprise }
      say_error "Must have `AdHoc', `Enterprise', or both build configurations" and return nil if configs.empty?
      acc
    end

    def check_app_store_config acc
      say_warning "Should have `AppStore' build configuration" unless acc[:build_configs][:app_store]
      acc
    end

    def detect_provisioning_profiles acc
      a = Dir['*.mobileprovision'].grep(/^(ad_hoc|app_store|enterprise)\./){$1.to_sym}
      acc[:provisioning_profiles] = a.each_with_object({}) { |p,h| h[p] = "#{p}.mobileprovision" }
      acc
    end

    def check_provisioning_profiles acc
      result = acc

      acc[:build_configs].each do |name, config|
        say_error "`#{config.name}' build configuration must have an `#{name}.mobileprovision' in project root" and result = nil unless acc[:provisioning_profiles][name]
      end
      result
    end
   end

  command :lint do |c|
    c.syntax = 'magnum lint'
    c.summary = 'Check for CI problems'
    c.description = 'Report if your project is missing or deviating from Magnum CI conventions.'
    c.action Linter, :lint
  end
end
