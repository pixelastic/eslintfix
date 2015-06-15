require_relative '../spec_helper.rb'

describe EslintFix do
  include SpecHelper

  before do
    init_fixture(__FILE__)
  end

  describe 'rule space-before-blocks' do
    it 'should add a space before {} block' do
      # Given
      @instance = EslintFix.new(fixture_file('no-space.js'))
      @instance.config = { 'space-before-blocks': true }
      # When
      actual = @instance.fix
      # Then
      expected = File.open(fixture_file('with-space.js')).read
      actual.must_equal expected
    end
    it 'should remove spaces before {} blocks' do
      # Given
      @instance = EslintFix.new(fixture_file('with-space.js'))
      @instance.config = { 'space-before-blocks': false }
      # When
      actual = @instance.fix
      # Then
      expected = File.open(fixture_file('no-space.js')).read
      actual.must_equal expected
    end
  end
end
