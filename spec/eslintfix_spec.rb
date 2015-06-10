require_relative './spec_helper.rb'

# include SpecHelper
describe EslintFix do
  include SpecHelper

  before do
    init_fixture(__FILE__)
  end

  describe 'initialize' do
    it 'should accept a file as input' do
      # Given
      input = fixture_file('i-am-here.js')
      # When
      actual = EslintFix.new(input)
      # Then
      actual.file.must_equal input
    end

    it 'should not accept non-existent files' do
      # Given
      input = fixture_file('i-am-not-here.js')
      # When
      actual = EslintFix.new(input)
      # Then
      actual.file.must_be_nil
    end

    it 'should expand filenames' do
      # Given
      input = fixture_file('../eslintfix/./i-am-here.js')
      # When
      actual = EslintFix.new(input)
      # Then
      actual.file.must_equal fixture_file('i-am-here.js')
    end
  end
end
