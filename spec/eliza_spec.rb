require 'spec_helper'

describe Eliza do
  it 'version is 0.1.1' do
    expect(Eliza::VERSION).to eq('0.0.1')
  end
  it 'can create an interpreter' do
    interpreter = Eliza::Interpreter.new
    expect(interpreter).to_not be_nil
  end
  describe Eliza::Interpreter do
    let(:interpreter) { Eliza::Interpreter.new }
    describe 'last_repsonse' do
      it 'knows what it said last' do
        expect(interpreter.last_response).to_not be_nil
      end
      it 'first asks you to explain your problem' do
        expect(interpreter.last_response).to include 'Please describe your problem'
      end
    end
  end
end
