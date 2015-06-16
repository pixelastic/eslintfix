require_relative '../spec_helper.rb'

describe EslintFix do
  include SpecHelper

  before do
    init_fixture(__FILE__)
  end

  describe 'rule indent' do
    it 'should convert indentation from tabs to spaces' do
      # Given
      @instance = EslintFix.new(fixture_file('tabs.js'))
      @instance.config = stringify_hash('indent': [2, 2])
      # When
      actual = @instance.fix
      # Then
      expected = File.open(fixture_file('2-spaces.js')).read
      actual.must_equal expected
    end
    it 'should convert tabs to default spaces (4)' do
      # Given
      @instance = EslintFix.new(fixture_file('tabs.js'))
      @instance.config = stringify_hash('indent': 1)
      # When
      actual = @instance.fix
      # Then
      expected = File.open(fixture_file('4-spaces.js')).read
      actual.must_equal expected
    end
    it 'should convert indentation from 2 spaces to 4 spaces' do
      # Given
      @instance = EslintFix.new(fixture_file('4-spaces.js'))
      @instance.config = stringify_hash('indent': [2, 2])
      # When
      actual = @instance.fix
      # Then
      expected = File.open(fixture_file('2-spaces.js')).read
      actual.must_equal expected
    end
    it 'should convert indentation from 2 spaces to tabs' do
      # Given
      @instance = EslintFix.new(fixture_file('2-spaces.js'))
      @instance.config = stringify_hash('indent': [2, 'tab'])
      # When
      actual = @instance.fix
      # Then
      expected = File.open(fixture_file('tabs.js')).read
      actual.must_equal expected
    end
    it 'should convert mixed tabs and spaces to spaces' do
      # Given
      @instance = EslintFix.new(fixture_file('mixed.js'))
      @instance.config = stringify_hash('indent': [2, 2])
      # When
      actual = @instance.fix
      # Then
      expected = File.open(fixture_file('2-spaces.js')).read
      actual.must_equal expected
    end
  end
end

