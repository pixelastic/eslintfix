require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/reporters'
require 'awesome_print'
require_relative '../lib/eslintfix.rb'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# Shared helper methods
module SpecHelper
  def init_fixture(base_file)
    fixture_path = File.expand_path(File.join('.', 'spec', 'fixtures'))
    test_name = File.basename(base_file).gsub('_spec.rb', '')
    @fixture_path = File.join(fixture_path, test_name)
  end

  def fixture_file(file)
    File.expand_path(File.join(@fixture_path, file))
  end

  def stringify_hash(hash)
    JSON.parse(JSON.generate(hash))
  end
end
