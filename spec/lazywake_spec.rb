# frozen_string_literal: true
require 'spec_helper'
require 'lazywake'

describe Lazywake do
  it 'should have a VERSION constant' do
    expect(subject.const_get('VERSION')).to_not be_empty
  end
end
