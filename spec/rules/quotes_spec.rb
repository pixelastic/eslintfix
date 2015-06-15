require_relative '../spec_helper.rb'

describe EslintFix do
  include SpecHelper

  before do
    init_fixture(__FILE__)
  end

  describe 'rule quotes' do
    it 'should use double quotes when set to double' do
      # Given
      @instance = EslintFix.new(fixture_file('single.js'))
      @instance.config = { 'quotes': 'double' }
      # When
      actual = @instance.fix
      # Then
      expected = File.open(fixture_file('double.js')).read
      actual.must_equal expected
    end
    it 'should use single quotes when set to single' do
      # Given
      @instance = EslintFix.new(fixture_file('double.js'))
      @instance.config = { 'quotes': 'single' }
      # When
      actual = @instance.fix
      # Then
      expected = File.open(fixture_file('single.js')).read
      actual.must_equal expected
    end
  end
end
