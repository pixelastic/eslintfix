require_relative './spec_helper.rb'

# include SpecHelper
describe EslintFix do
  include SpecHelper

  before do
    @fixture_path = fixture_path(__FILE__)
  end

  describe 'initialize' do
    it 'should accept files as input' do
      # Given
      files = [
        @fixture_path + '/i-am-here.js',
        @fixture_path + '/i-am-also-here.js'
      ]
      # When
      actual = EslintFix.new(*files)
      # Then
      actual.files.must_equal files
    end

    it 'should remove non-existent files' do
      # Given
      files = [
        @fixture_path + '/i-am-here.js',
        @fixture_path + '/i-am-not-here.js',
        @fixture_path + '/i-am-also-here.js'
      ]
      # When
      actual = EslintFix.new(*files)
      # Then
      actual.files.size.must_equal 2
      actual.files.wont_include(@fixture_path + '/i-am-not-here.js')
    end

    it 'should expand filenames' do
      # Given
      files = [
        @fixture_path + '/../eslintfix/./i-am-here.js'
      ]
      # When
      actual = EslintFix.new(*files)
      # Then
      actual.files.must_include(@fixture_path + '/i-am-here.js')
    end
  end
end
