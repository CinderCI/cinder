module FakeWorkspace
  module SpecHelpers
    def self.included example_group
      working_dir = Dir.getwd

      example_group.before :each do
        ws = example.metadata[:ws]
        raise "must specify fake workspace with :ws" unless ws
        workspace = File.join 'spec/fixtures', ws
        begin
          Dir.chdir workspace
        rescue
          Dir.chdir working_dir
          raise "No fake workspace found at #{workspace}"
        end
      end

      example_group.after :each do
        Dir.chdir working_dir
      end
    end
  end
end
