require_relative '../spec_helper.rb'

describe EslintFix do
  include SpecHelper

  before do
    init_fixture(__FILE__)
  end

  describe 'rule space-in-parens' do
    it 'should add spaces if set to true' do
      # Given
      @instance = EslintFix.new(fixture_file('without-spaces.js'))
      @instance.config = stringify_hash('space-in-parens': true)
      # When
      actual = @instance.fix
      # Then
      expected = File.open(fixture_file('with-spaces.js')).read
      actual.must_equal expected
    end
    it 'should remove spaces if set to false' do
      # Given
      @instance = EslintFix.new(fixture_file('with-spaces.js'))
      @instance.config = stringify_hash('space-in-parens': false)
      # When
      actual = @instance.fix
      # Then
      expected = File.open(fixture_file('without-spaces.js')).read
      actual.must_equal expected
    end
  end
end
