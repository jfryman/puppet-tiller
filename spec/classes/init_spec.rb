require 'spec_helper'
describe 'tiller' do

  context 'with defaults for all parameters' do
    it { should contain_class('tiller') }
  end
end
