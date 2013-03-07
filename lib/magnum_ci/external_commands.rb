module MagnumCI
  def self.pod! command
    execute_command 'bin/pod', command
  end
  def self.mkdir! command
    execute_command :mkdir, command
  end
  def self.cp! command
    execute_command :cp, command
  end
  def self.security! command
    execute_command :security, command
  end
  def self.git! command
    execute_command :git, command
  end
  def self.PlistBuddy! command
    execute_command '/usr/libexec/PlistBuddy', command
  end
  def self.ipa! command
    execute_command 'bin/ipa', command
  end

  private

  def self.execute_command name, command
    bin = `which #{name}`.strip
    say_error "command not found: #{name}" and abort if bin.empty?

    require 'open4'

    full_command = "#{bin} #{command}"

    out = ''
    options = {:stdout => out, :stderr => out, :status => true}
    status  = Open4.spawn(full_command, options)
    unless status.success?
      log name, out
      say_error "#{bin} exited with status #{status.exitstatus}" and abort
    end
    out
  end
end
