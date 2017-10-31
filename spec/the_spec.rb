require_relative './spec_helper'
require_relative '../app'

describe 'challenge' do
  it 'hi' do    app = App.new
    expect(thing()).to eq 'yo'
  end
end
