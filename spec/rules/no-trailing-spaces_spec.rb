require_relative '../spec_helper.rb'

describe EslintFix do
  include SpecHelper

  before do
    init_fixture(__FILE__)
    @instance = EslintFix.new(fixture_file('input.js'))
    @instance.config = { 'no-trailing-spaces': true }
  end

  describe 'rule no-trailing-spaces' do
    it 'should remove trailing spaces' do
      # Given
      expected = File.open(fixture_file('expected.js')).read
      # When
      actual = @instance.fix
      # Then
      actual.must_equal expected
    end
  end
end
