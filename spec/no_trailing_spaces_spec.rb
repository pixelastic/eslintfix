require_relative './spec_helper.rb'

describe EslintFix do
  before do
    @instance = EslintFix.new
  end

  describe 'when asked if has' do
    it 'should say yes' do
      @instance.has.must_equal 'yes'
    end
  end
end
