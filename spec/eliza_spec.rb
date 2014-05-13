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
        expect(interpreter.last_response)
          .to include 'Please describe your problem'
      end
    end
    describe 'process_input' do
      it 'processes input' do
        output = interpreter.process_input 'This is a sentence.'
        expect(output).to be_instance_of(String)
      end
      it 'says something different each time' do
        output1 = interpreter.process_input 'This is a sentence.'
        output2 = interpreter.process_input 'My car is yellow.'
        expect(output1).to_not eq output2
      end
      it 'sets done to true if the user quits' do
        output = interpreter.process_input 'quit'
        expect(output).to include 'Goodbye'
        expect(interpreter.done).to be_true
      end
    end
  end
end
