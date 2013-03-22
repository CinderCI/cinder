require "spec_helper"
require 'stringio'
require "magnum_ci/commands/lint"

describe MagnumCI::Linter do

  before do
    mock_terminal
  end

  describe "command output" do

    let(:linter) { MagnumCI::Linter.new }
    subject do
      linter._lint
      @output.string
    end

    context "with everything set up properly", :fakews, :ws => 'proper' do
      it { should =~ /OK to go/ }
    end

    context "without projects", :fakews, :ws => 'sans-project' do
      it { should =~ /No Xcode project found/ }
      it { should_not =~ /OK to go/ }
    end

    context "without workspace", :fakews, :ws => 'sans-workspace' do
      it { should =~ /No Xcode workspace found/ }
      it { should_not =~ /OK to go/ }
    end

    context "with more than 1 workspace", :fakews, :ws => 'multiple-workspaces' do
      it { should =~ /There can be only one Xcode workspace/ }
      it { should_not =~ /OK to go/ }
    end

    context "with whitespace in workspace name", :fakews, :ws => 'whitespace-workspace' do
      it { should =~ /Workspace name `Foo App' must not contain whitespace/ }
      it { should_not =~ /OK to go/ }
    end

    context "with .xcodeproj name differing from workspace", :fakews, :ws => 'workspace-project-mismatch' do
      it { should =~ /Xcode project name `Bar' must match workspace name `Foo'/ }
      it { should_not =~ /OK to go/ }
    end

    context "with no projects matching workspace name", :fakews, :ws => 'workspace-projects-mismatch' do
      it { should =~ /One Xcode project name must match workspace name `Foo'/ }
      it { should_not =~ /OK to go/ }
    end

    context "with unconventional name", :fakews, :ws => 'lowercase' do
      it { should =~ /Workspace name `foo' should be CamelCase/ }
      it { should =~ /OK to go/ }
    end

    context "without Podfile", :fakews, :ws => 'sans-podfile' do
      it { should =~ /No CocoaPods Podfile found/ }
      it { should_not =~ /OK to go/ }
    end

    context "with empty Podfile", :fakews, :ws => 'empty-podfile' do
      it { should =~ /CocoaPods platform must be iOS/ }
      it { should =~ /Must have at least one CocoaPods dependency/ }
      it { should_not =~ /OK to go/ }
    end

    context "without a target", :fakews, :ws => 'sans-target' do
      it { should =~ /Xcode project must have at least one target/ }
      it { should_not =~ /OK to go/ }
    end

    context "with target name differing from workspace", :fakews, :ws => 'workspace-target-mismatch' do
      it { should =~ /Target name `Stay on target' must match workspace name `Foo'/ }
      it { should_not =~ /OK to go/ }
    end

    context "with no targets matching workspace name", :fakews, :ws => 'workspace-targets-mismatch' do
      it { should =~ /One Xcode target name must match workspace name `Foo'/ }
      it { should_not =~ /OK to go/ }
    end

    context "without testing build configuration", :fakews, :ws => 'sans-ad_hoc-or-enterprise-config' do
      it { should =~ /Must have `AdHoc', `Enterprise', or both build configurations/ }
      it { should_not =~ /OK to go/ }
    end

    context "with both testing build configurations", :fakews, :ws => 'both-configs' do
      it { should =~ /OK to go/ }

      context "without AdHoc provisioning profile", :ws => 'both-configs-sans-ad_hoc-provisioning' do
        it { should =~ /`AdHoc' build configuration must have an `ad_hoc.mobileprovision' in project root/ }
        it { should_not =~ /OK to go/ }
      end

      context "without Enterprise provisioning profile", :ws => 'both-configs-sans-enterprise-provisioning' do
        it { should =~ /`Enterprise' build configuration must have an `enterprise.mobileprovision' in project root/ }
        it { should_not =~ /OK to go/ }
      end
    end
  end
end
