require_relative '../spec_helper.rb'

describe EslintFix do
  include SpecHelper

  before do
    init_fixture(__FILE__)
  end

  describe 'rule no-multi-spaces' do
    it 'should remove useless spaces' do
      # Given
      @instance = EslintFix.new(fixture_file('with-spaces.js'))
      @instance.config = { 'no-multi-spaces': true }
      # When
      actual = @instance.fix
      # Then
      expected = File.open(fixture_file('without-spaces.js')).read
      actual.must_equal expected
    end
  end
end
