require_relative '../spec_helper.rb'

describe EslintFix do
  include SpecHelper

  before do
    init_fixture(__FILE__)
  end

  describe 'rule key-spacing' do
    it 'should add space before if beforeColon' do
      # Given
      @instance = EslintFix.new(fixture_file('no-space-before-space-after.js'))
      @instance.config = stringify_hash(
        'key-spacing': [1, { 'beforeColon': true }]
      )
      # When
      actual = @instance.fix
      # Then
      expected = File.open(fixture_file('space-before-space-after.js')).read
      actual.must_equal expected
    end
    it 'should add space after if afterColon' do
      # Given
      @instance = EslintFix.new(fixture_file('space-before-no-space-after.js'))
      @instance.config = stringify_hash(
        'key-spacing': [1, { 'afterColon': true }]
      )
      # When
      actual = @instance.fix
      # Then
      expected = File.open(fixture_file('space-before-space-after.js')).read
      actual.must_equal expected
    end
    it 'should remove space after if afterColon = false' do
      # Given
      @instance = EslintFix.new(fixture_file('space-before-space-after.js'))
      @instance.config = stringify_hash(
        'key-spacing': [1, { 'afterColon': false }]
      )
      # When
      actual = @instance.fix
      # Then
      expected = File.open(fixture_file('space-before-no-space-after.js')).read
      actual.must_equal expected
    end
    it 'should remove space before if beforeColon = false' do
      # Given
      @instance = EslintFix.new(fixture_file('space-before-no-space-after.js'))
      @instance.config = stringify_hash(
        'key-spacing': [1, { 'beforeColon': false }]
      )
      # When
      actual = @instance.fix
      # Then
      expected = File.open(fixture_file('no-space-before-no-space-after.js')).read
      actual.must_equal expected
    end
  end
end
