require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/reporters'
require 'awesome_print'
require_relative '../lib/eslintfix.rb'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# Shared helper methods
module SpecHelper
  def fixture_path(test_file)
    fixture_path = File.expand_path(File.join('.', 'spec', 'fixtures'))
    test_name = File.basename(test_file).gsub('_spec.rb', '')
    File.join(fixture_path, test_name)
  end
end
