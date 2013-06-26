module Cinder
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
  def self.xctool! command
    execute_command :xctool, command
  end

  private

  def self.execute_command name, command
    bin = `which #{name}`.strip
    say_error "command not found: #{name}" and abort if bin.empty?

    full_command = "#{bin} #{command}"

    IO.popen(full_command, external_encoding: "UTF-8") do |data|
      data.each { |s| print s }
      data.close
      say_error "Failed: Exited with status #{$?.to_i}" and abort unless $?.to_i == 0
    end
  end
end
