require "rspec"
require 'fake_workspace'
require 'commander'
require 'commander/delegates'

include Commander::UI
include Commander::UI::AskForClass
include Commander::Delegates

def mock_terminal
  @input, @output = StringIO.new, StringIO.new
  $terminal = HighLine.new @input, @output
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.color_enabled = true
  config.order = 'rand'
  config.include FakeWorkspace::SpecHelpers, :fakews
end
